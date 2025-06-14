import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/diary_model.dart';
import '../../../../core/models/api/analysis_models.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/analysis_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/diary_repository.dart';
import '../../data/repositories/diary_repository_impl.dart';

// 서비스 Providers
final analysisServiceProvider = Provider<AnalysisService>((ref) => AnalysisService());
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// 일기 목록 Provider
final diariesProvider = StreamProvider<List<DiaryModel>>((ref) {
  final userId = FirebaseService.currentUserId;
  if (userId == null) {
    return Stream.value([]);
  }

  // 인덱스 문제를 피하기 위해 orderBy 제거
  // 클라이언트 사이드에서 정렬 처리
  return FirebaseService.diariesCollection
      .where('userId', isEqualTo: userId)
      .limit(50) // 제한 수 증가
      .snapshots()
      .map((snapshot) {
    final diaries = snapshot.docs
        .map((doc) => DiaryModel.fromFirestore(doc))
        .toList();
    
    // 클라이언트 사이드에서 정렬 (최신 순)
    diaries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return diaries;
  });
});

// 특정 일기 Provider
final diaryProvider = StreamProvider.family<DiaryModel?, String>((ref, diaryId) {
  return FirebaseService.diariesCollection
      .doc(diaryId)
      .snapshots()
      .map((doc) {
    if (doc.exists) {
      return DiaryModel.fromFirestore(doc);
    }
    return null;
  });
});

// 일기 Repository Provider
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepositoryImpl();
});

// ========== AI 분석 관련 Providers ==========

/// 일기 분석 결과 Provider
final diaryAnalysisProvider = FutureProvider.family<DiaryAnalysisResponse?, String>((ref, diaryId) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    return await analysisService.getAnalysisResult(diaryId);
  } catch (e) {
    return null; // 분석 결과가 없는 경우
  }
});

/// 사용자 감정 패턴 Provider
final userEmotionPatternsProvider = FutureProvider<UserEmotionPatterns?>((ref) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await analysisService.getEmotionPatterns(userId);
  } catch (e) {
    return null;
  }
});

/// 사용자 성격 분석 Provider
final userPersonalityProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await analysisService.getPersonalityAnalysis(userId);
  } catch (e) {
    return null;
  }
});

/// 사용자 종합 인사이트 Provider
final userOverallInsightsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await analysisService.getOverallInsights(userId);
  } catch (e) {
    return null;
  }
});

/// 분석 이력 Provider
final analysisHistoryProvider = FutureProvider.family<AnalysisHistoryResponse?, Map<String, dynamic>>((ref, params) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    final userId = params['userId'] as String?;
    final limit = params['limit'] as int?;
    final offset = params['offset'] as int?;
    
    if (userId == null) return null;
    
    return await analysisService.getAnalysisHistory(
      userId: userId,
      limit: limit,
      offset: offset,
    );
  } catch (e) {
    return null;
  }
});

/// 분석 통계 Provider
final analysisStatsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final analysisService = ref.watch(analysisServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await analysisService.getAnalysisStats(userId);
  } catch (e) {
    return null;
  }
});

// 일기 통계 Provider (기본 구현)
final diaryStatsProvider = Provider<Map<String, dynamic>>((ref) {
  // 실제로는 Firestore에서 통계 데이터를 가져와야 함
  return {
    'totalDiaries': 15,
    'thisWeekDiaries': 3,
    'emotionTrend': '긍정적',
    'longestStreak': 7,
  };
});

// ========== 일기 상태 관리 ==========

class DiaryState {
  final bool isLoading;
  final String? error;
  final bool isAnalyzing;
  final DiaryAnalysisResponse? lastAnalysis;

  const DiaryState({
    this.isLoading = false,
    this.error,
    this.isAnalyzing = false,
    this.lastAnalysis,
  });

  DiaryState copyWith({
    bool? isLoading,
    String? error,
    bool? isAnalyzing,
    DiaryAnalysisResponse? lastAnalysis,
  }) {
    return DiaryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      lastAnalysis: lastAnalysis ?? this.lastAnalysis,
    );
  }
}

class DiaryNotifier extends StateNotifier<DiaryState> {
  final DiaryRepository _diaryRepository;
  final AnalysisService _analysisService;

  DiaryNotifier(this._diaryRepository, this._analysisService) 
      : super(const DiaryState());

  /// 일기 작성 및 AI 분석
  Future<String?> createDiaryWithAnalysis({
    required String title,
    required String content,
    String? weather,
    String? mood,
    List<String>? activities,
    String? location,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final diaryId = const Uuid().v4();
      final userId = FirebaseService.currentUserId;
      
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 1. 일기 생성
      final diary = DiaryModel(
        id: diaryId,
        userId: userId,
        title: title,
        content: content,
        weather: weather,
        mood: mood,
        activities: activities ?? [],
        location: location,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 2. Firestore에 저장
      await _diaryRepository.createDiary(diary);

      // 3. AI 분석 요청 (비동기)
      _analyzeDiaryAsync(diaryId, content, weather, mood, activities, location);

      state = state.copyWith(isLoading: false);
      return diaryId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '일기 작성 실패: $e',
      );
      return null;
    }
  }

  /// 일기 수정
  Future<bool> updateDiary(DiaryModel diary) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _diaryRepository.updateDiary(diary);

      // 내용이 변경된 경우 재분석 (비동기)
      _analyzeDiaryAsync(
        diary.id,
        diary.content,
        diary.weather,
        diary.mood,
        diary.activities,
        diary.location,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '일기 수정 실패: $e',
      );
      return false;
    }
  }

  /// 일기 삭제
  Future<bool> deleteDiary(String diaryId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _diaryRepository.deleteDiary(diaryId);
      
      // 분석 결과도 삭제
      try {
        await _analysisService.deleteAnalysisResult(diaryId);
      } catch (e) {
        // 분석 결과 삭제 실패는 무시
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '일기 삭제 실패: $e',
      );
      return false;
    }
  }

  /// 비동기 AI 분석
  Future<void> _analyzeDiaryAsync(
    String diaryId,
    String content,
    String? weather,
    String? mood,
    List<String>? activities,
    String? location,
  ) async {
    state = state.copyWith(isAnalyzing: true);

    try {
      final metadata = _analysisService.createMetadata(
        weather: weather,
        moodBefore: mood,
        activities: activities,
        location: location,
      );

      final analysisResult = await _analysisService.analyzeDiary(
        diaryId: diaryId,
        content: content,
        metadata: metadata,
      );

      state = state.copyWith(
        isAnalyzing: false,
        lastAnalysis: analysisResult,
      );
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: 'AI 분석 실패: $e',
      );
    }
  }

  /// 수동 분석 요청
  Future<DiaryAnalysisResponse?> requestAnalysis(String diaryId, String content) async {
    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      final analysisResult = await _analysisService.analyzeDiary(
        diaryId: diaryId,
        content: content,
      );

      state = state.copyWith(
        isAnalyzing: false,
        lastAnalysis: analysisResult,
      );

      return analysisResult;
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: '분석 요청 실패: $e',
      );
      return null;
    }
  }

  /// 에러 상태 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// DiaryNotifier Provider
final diaryNotifierProvider = StateNotifierProvider<DiaryNotifier, DiaryState>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  final analysisService = ref.watch(analysisServiceProvider);
  return DiaryNotifier(repository, analysisService);
});
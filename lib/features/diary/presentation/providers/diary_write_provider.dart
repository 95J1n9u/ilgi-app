import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/diary_model.dart';
import '../../../../core/services/firebase_service.dart';

// 일기 작성 상태
class DiaryWriteState {
  final String content;
  final List<String> selectedEmotions;
  final String? selectedWeather;
  final List<String> selectedActivities;
  final bool aiAnalysisConsent;
  final bool isLoading;
  final String? error;

  const DiaryWriteState({
    this.content = '',
    this.selectedEmotions = const [],
    this.selectedWeather,
    this.selectedActivities = const [],
    this.aiAnalysisConsent = true,
    this.isLoading = false,
    this.error,
  });

  DiaryWriteState copyWith({
    String? content,
    List<String>? selectedEmotions,
    String? selectedWeather,
    List<String>? selectedActivities,
    bool? aiAnalysisConsent,
    bool? isLoading,
    String? error,
  }) {
    return DiaryWriteState(
      content: content ?? this.content,
      selectedEmotions: selectedEmotions ?? this.selectedEmotions,
      selectedWeather: selectedWeather ?? this.selectedWeather,
      selectedActivities: selectedActivities ?? this.selectedActivities,
      aiAnalysisConsent: aiAnalysisConsent ?? this.aiAnalysisConsent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // 저장 가능 여부
  bool get canSave =>
      content.trim().isNotEmpty &&
          selectedEmotions.isNotEmpty &&
          !isLoading;
}

// 일기 작성 Notifier
class DiaryWriteNotifier extends StateNotifier<DiaryWriteState> {
  DiaryWriteNotifier() : super(const DiaryWriteState());

  DiaryModel? _editingDiary;

  // 기존 일기 로드 (편집 모드)
  void loadExistingDiary(DiaryModel diary) {
    _editingDiary = diary;
    state = state.copyWith(
      content: diary.content,
      selectedEmotions: diary.emotions,
      selectedWeather: diary.weather,
      selectedActivities: diary.activities,
    );
  }

  // 내용 업데이트
  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  // 감정 추가
  void addEmotion(String emotion) {
    if (!state.selectedEmotions.contains(emotion)) {
      final newEmotions = [...state.selectedEmotions, emotion];
      state = state.copyWith(selectedEmotions: newEmotions);
    }
  }

  // 감정 제거
  void removeEmotion(String emotion) {
    final newEmotions = state.selectedEmotions
        .where((e) => e != emotion)
        .toList();
    state = state.copyWith(selectedEmotions: newEmotions);
  }

  // 날씨 설정
  void setWeather(String? weather) {
    state = state.copyWith(selectedWeather: weather);
  }

  // 활동 추가
  void addActivity(String activity) {
    if (!state.selectedActivities.contains(activity)) {
      final newActivities = [...state.selectedActivities, activity];
      state = state.copyWith(selectedActivities: newActivities);
    }
  }

  // 활동 제거
  void removeActivity(String activity) {
    final newActivities = state.selectedActivities
        .where((a) => a != activity)
        .toList();
    state = state.copyWith(selectedActivities: newActivities);
  }

  // AI 분석 동의 설정
  void setAIAnalysisConsent(bool consent) {
    state = state.copyWith(aiAnalysisConsent: consent);
  }

  // 일기 저장
  Future<void> saveDiary() async {
    if (!state.canSave) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = FirebaseService.currentUserId;
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      final now = DateTime.now();

      if (_editingDiary != null) {
        // 수정 모드
        final updatedDiary = _editingDiary!.copyWith(
          content: state.content.trim(),
          emotions: state.selectedEmotions,
          weather: state.selectedWeather,
          activities: state.selectedActivities,
          updatedAt: now,
        );

        await FirebaseService.diariesCollection
            .doc(_editingDiary!.id)
            .update(updatedDiary.toJson());
      } else {
        // 새 일기 작성
        final diaryId = const Uuid().v4();
        final diary = DiaryModel(
          id: diaryId,
          userId: userId,
          content: state.content.trim(),
          emotions: state.selectedEmotions,
          weather: state.selectedWeather,
          activities: state.selectedActivities,
          analysisStatus: state.aiAnalysisConsent ? 'pending' : 'skipped',
          createdAt: now,
          updatedAt: now,
        );

        await FirebaseService.diariesCollection
            .doc(diaryId)
            .set(diary.toJson());

        // AI 분석 요청 (비동기)
        if (state.aiAnalysisConsent) {
          _requestAIAnalysis(diaryId);
        }
      }

      // 상태 초기화
      _resetState();

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // AI 분석 요청 (비동기)
  Future<void> _requestAIAnalysis(String diaryId) async {
    // TODO: FastAPI 서버로 분석 요청 전송
    // 현재는 상태만 업데이트
    try {
      await FirebaseService.diariesCollection
          .doc(diaryId)
          .update({'analysisStatus': 'processing'});
    } catch (e) {
      print('AI 분석 요청 실패: $e');
    }
  }

  // 상태 초기화
  void _resetState() {
    _editingDiary = null;
    state = const DiaryWriteState();
  }

  // Provider dispose시 호출
  void dispose() {
    _resetState();
  }
}

// Provider 정의
final diaryWriteNotifierProvider =
StateNotifierProvider<DiaryWriteNotifier, DiaryWriteState>((ref) {
  return DiaryWriteNotifier();
});
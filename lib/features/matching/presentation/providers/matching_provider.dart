import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/api/matching_models.dart';
import '../../../../core/services/matching_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/errors/exceptions.dart';

// 매칭 서비스 Provider
final matchingServiceProvider = Provider<MatchingService>((ref) => MatchingService());

// ========== 매칭 후보 관련 Providers ==========

/// 매칭 후보 목록 Provider
final matchingCandidatesProvider = FutureProvider.family<MatchingCandidatesResponse?, Map<String, dynamic>>((ref, params) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    
    final limit = params['limit'] as int?;
    final minCompatibility = params['minCompatibility'] as double?;
    final filters = params['filters'] as MatchingFilters?;
    
    return await matchingService.getMatchingCandidates(
      limit: limit,
      minCompatibility: minCompatibility,
      filters: filters,
    );
  } catch (e) {
    throw ApiException('매칭 후보 조회 실패: $e');
  }
});

/// 호환성 점수 계산 Provider
final compatibilityProvider = FutureProvider.family<CompatibilityResponse?, String>((ref, targetUserId) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    return await matchingService.calculateCompatibility(targetUserId: targetUserId);
  } catch (e) {
    throw ApiException('호환성 계산 실패: $e');
  }
});

/// 매칭용 사용자 프로필 Provider
final matchingProfileProvider = FutureProvider.family<MatchingUserProfile?, String>((ref, userId) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    return await matchingService.getMatchingProfile(userId);
  } catch (e) {
    return null; // 프로필이 없는 경우
  }
});

/// 현재 사용자의 매칭 프로필 Provider
final myMatchingProfileProvider = FutureProvider<MatchingUserProfile?>((ref) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await matchingService.getMatchingProfile(userId);
  } catch (e) {
    return null;
  }
});

/// 매칭 선호도 설정 Provider
final matchingPreferencesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    return await matchingService.getMatchingPreferences();
  } catch (e) {
    return null;
  }
});

/// 매칭 이력 Provider
final matchingHistoryProvider = FutureProvider.family<Map<String, dynamic>?, Map<String, int>>((ref, params) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    final limit = params['limit'];
    final offset = params['offset'];
    
    return await matchingService.getMatchingHistory(
      limit: limit,
      offset: offset,
    );
  } catch (e) {
    return null;
  }
});

/// 매칭 분석 데이터 Provider
final matchingAnalyticsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final matchingService = ref.watch(matchingServiceProvider);
    final userId = FirebaseService.currentUserId;
    if (userId == null) return null;
    
    return await matchingService.getMatchingAnalytics(userId);
  } catch (e) {
    return null;
  }
});

// ========== 매칭 상태 관리 ==========

class MatchingState {
  final bool isLoading;
  final String? error;
  final List<MatchingCandidate> candidates;
  final MatchingFilters? currentFilters;
  final bool isUpdatingPreferences;

  const MatchingState({
    this.isLoading = false,
    this.error,
    this.candidates = const [],
    this.currentFilters,
    this.isUpdatingPreferences = false,
  });

  MatchingState copyWith({
    bool? isLoading,
    String? error,
    List<MatchingCandidate>? candidates,
    MatchingFilters? currentFilters,
    bool? isUpdatingPreferences,
  }) {
    return MatchingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      candidates: candidates ?? this.candidates,
      currentFilters: currentFilters ?? this.currentFilters,
      isUpdatingPreferences: isUpdatingPreferences ?? this.isUpdatingPreferences,
    );
  }
}

class MatchingNotifier extends StateNotifier<MatchingState> {
  final MatchingService _matchingService;

  MatchingNotifier(this._matchingService) : super(const MatchingState());

  /// 매칭 후보 조회
  Future<void> loadMatchingCandidates({
    int? limit,
    double? minCompatibility,
    MatchingFilters? filters,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _matchingService.getMatchingCandidates(
        limit: limit,
        minCompatibility: minCompatibility,
        filters: filters,
      );

      state = state.copyWith(
        isLoading: false,
        candidates: response.candidates,
        currentFilters: filters,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '매칭 후보 조회 실패: $e',
      );
    }
  }

  /// 매칭 필터 적용
  Future<void> applyFilters(MatchingFilters filters) async {
    await loadMatchingCandidates(filters: filters);
  }

  /// 매칭 선호도 업데이트
  Future<bool> updatePreferences({
    List<int>? ageRange,
    List<String>? locationPreference,
    List<String>? mbtiPreferences,
    List<String>? valuePriorities,
    LifestylePreferences? lifestylePreferences,
  }) async {
    state = state.copyWith(isUpdatingPreferences: true, error: null);

    try {
      await _matchingService.updateMatchingPreferences(
        ageRange: ageRange,
        locationPreference: locationPreference,
        mbtiPreferences: mbtiPreferences,
        valuePriorities: valuePriorities,
        lifestylePreferences: lifestylePreferences,
      );

      state = state.copyWith(isUpdatingPreferences: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdatingPreferences: false,
        error: '선호도 업데이트 실패: $e',
      );
      return false;
    }
  }

  /// 매칭 피드백 제출
  Future<bool> submitFeedback({
    required String matchId,
    required String feedbackType,
    required int rating,
    String? comments,
    InteractionQuality? interactionQuality,
  }) async {
    try {
      await _matchingService.submitMatchingFeedback(
        matchId: matchId,
        feedbackType: feedbackType,
        rating: rating,
        comments: comments,
        interactionQuality: interactionQuality,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: '피드백 제출 실패: $e');
      return false;
    }
  }

  /// 후보 목록에서 특정 후보 제거 (스와이프 등)
  void removeCandidate(String candidateId) {
    final updatedCandidates = state.candidates
        .where((candidate) => candidate.candidateId != candidateId)
        .toList();
    
    state = state.copyWith(candidates: updatedCandidates);
  }

  /// 에러 상태 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 매칭 상태 초기화
  void reset() {
    state = const MatchingState();
  }
}

/// MatchingNotifier Provider
final matchingNotifierProvider = StateNotifierProvider<MatchingNotifier, MatchingState>((ref) {
  final matchingService = ref.watch(matchingServiceProvider);
  return MatchingNotifier(matchingService);
});

// ========== 유틸리티 Providers ==========

/// 호환성 점수별 색상 Provider
final compatibilityColorProvider = Provider.family<String, double>((ref, score) {
  final matchingService = ref.watch(matchingServiceProvider);
  return matchingService.getCompatibilityColor(score);
});

/// 호환성 점수 텍스트 Provider
final compatibilityTextProvider = Provider.family<String, double>((ref, score) {
  final matchingService = ref.watch(matchingServiceProvider);
  return matchingService.compatibilityScoreToText(score);
});

/// MBTI 호환성 확인 Provider
final mbtiCompatibilityProvider = Provider.family<bool, Map<String, String>>((ref, mbtiPair) {
  final matchingService = ref.watch(matchingServiceProvider);
  final myMbti = mbtiPair['my'] ?? '';
  final targetMbti = mbtiPair['target'] ?? '';
  
  return matchingService.isCompatibleMbti(myMbti, targetMbti);
});

/// 연령대 호환성 확인 Provider
final ageCompatibilityProvider = Provider.family<bool, Map<String, int>>((ref, agePair) {
  final matchingService = ref.watch(matchingServiceProvider);
  final myAge = agePair['my'] ?? 0;
  final targetAge = agePair['target'] ?? 0;
  
  return matchingService.isCompatibleAge(myAge, targetAge);
});

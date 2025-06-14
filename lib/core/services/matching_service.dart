import '../models/api/matching_models.dart';
import '../network/api_client.dart';
import '../services/auth_service.dart';
import '../errors/exceptions.dart';

class MatchingService {
  static MatchingService? _instance;
  factory MatchingService() => _instance ??= MatchingService._internal();
  MatchingService._internal();

  final ApiClient _apiClient = ApiClient();
  final AuthService _authService = AuthService();

  /// 매칭 후보 추천 요청
  Future<MatchingCandidatesResponse> getMatchingCandidates({
    int? limit,
    double? minCompatibility,
    MatchingFilters? filters,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = MatchingCandidatesRequest(
        limit: limit,
        minCompatibility: minCompatibility,
        filters: filters,
      );

      return await _apiClient.matchingApi.getMatchingCandidates(
        headers['Authorization']!,
        request,
      );
    } catch (e) {
      throw ApiException('매칭 후보 조회 실패: $e');
    }
  }

  /// 호환성 점수 계산
  Future<CompatibilityResponse> calculateCompatibility({
    required String targetUserId,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = CompatibilityRequest(
        targetUserId: targetUserId,
      );

      return await _apiClient.matchingApi.calculateCompatibility(
        headers['Authorization']!,
        request,
      );
    } catch (e) {
      throw ApiException('호환성 계산 실패: $e');
    }
  }

  /// 매칭용 사용자 프로필 조회
  Future<MatchingUserProfile> getMatchingProfile(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.matchingApi.getMatchingProfile(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('매칭 프로필 조회 실패: $e');
    }
  }

  /// 매칭 선호도 설정 업데이트
  Future<void> updateMatchingPreferences({
    List<int>? ageRange,
    List<String>? locationPreference,
    List<String>? mbtiPreferences,
    List<String>? valuePriorities,
    LifestylePreferences? lifestylePreferences,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = UpdatePreferencesRequest(
        ageRange: ageRange,
        locationPreference: locationPreference,
        mbtiPreferences: mbtiPreferences,
        valuePriorities: valuePriorities,
        lifestylePreferences: lifestylePreferences,
      );

      await _apiClient.matchingApi.updateMatchingPreferences(
        headers['Authorization']!,
        request,
      );
    } catch (e) {
      throw ApiException('매칭 선호도 업데이트 실패: $e');
    }
  }

  /// 매칭 선호도 설정 조회
  Future<Map<String, dynamic>> getMatchingPreferences() async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.matchingApi.getMatchingPreferences(
        headers['Authorization']!,
      );
    } catch (e) {
      throw ApiException('매칭 선호도 조회 실패: $e');
    }
  }

  /// 매칭 이력 조회
  Future<Map<String, dynamic>> getMatchingHistory({
    int? limit,
    int? offset,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.matchingApi.getMatchingHistory(
        headers['Authorization']!,
        limit,
        offset,
      );
    } catch (e) {
      throw ApiException('매칭 이력 조회 실패: $e');
    }
  }

  /// 매칭 피드백 제출
  Future<void> submitMatchingFeedback({
    required String matchId,
    required String feedbackType,
    required int rating,
    String? comments,
    InteractionQuality? interactionQuality,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = MatchingFeedbackRequest(
        matchId: matchId,
        feedbackType: feedbackType,
        rating: rating,
        comments: comments,
        interactionQuality: interactionQuality,
      );

      await _apiClient.matchingApi.submitMatchingFeedback(
        headers['Authorization']!,
        request,
      );
    } catch (e) {
      throw ApiException('매칭 피드백 제출 실패: $e');
    }
  }

  /// 매칭 분석 데이터 조회
  Future<Map<String, dynamic>> getMatchingAnalytics(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.matchingApi.getMatchingAnalytics(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('매칭 분석 데이터 조회 실패: $e');
    }
  }

  /// 매칭 필터 생성 도우미
  MatchingFilters createFilters({
    List<int>? ageRange,
    String? location,
    List<String>? interests,
    List<String>? mbtiTypes,
  }) {
    return MatchingFilters(
      ageRange: ageRange,
      location: location,
      interests: interests,
      mbtiTypes: mbtiTypes,
    );
  }

  /// 라이프스타일 선호도 생성 도우미
  LifestylePreferences createLifestylePreferences({
    List<String>? activityTypes,
    String? socialFrequency,
    String? communicationStyle,
  }) {
    return LifestylePreferences(
      activityTypes: activityTypes,
      socialFrequency: socialFrequency,
      communicationStyle: communicationStyle,
    );
  }

  /// 상호작용 품질 생성 도우미
  InteractionQuality createInteractionQuality({
    required int communication,
    required int compatibility,
    required int interestLevel,
  }) {
    return InteractionQuality(
      communication: communication,
      compatibility: compatibility,
      interestLevel: interestLevel,
    );
  }

  /// 호환성 점수를 텍스트로 변환
  String compatibilityScoreToText(double score) {
    if (score >= 0.9) return '매우 높음';
    if (score >= 0.8) return '높음';
    if (score >= 0.7) return '좋음';
    if (score >= 0.6) return '보통';
    if (score >= 0.5) return '낮음';
    return '매우 낮음';
  }

  /// 호환성 점수에 따른 색상 반환
  String getCompatibilityColor(double score) {
    if (score >= 0.8) return '#4CAF50'; // 녹색
    if (score >= 0.7) return '#8BC34A'; // 연녹색
    if (score >= 0.6) return '#FFC107'; // 노란색
    if (score >= 0.5) return '#FF9800'; // 주황색
    return '#F44336'; // 빨간색
  }

  /// MBTI 호환성 매칭
  bool isCompatibleMbti(String myMbti, String targetMbti) {
    // 일반적인 MBTI 호환성 규칙 (간단한 버전)
    final compatiblePairs = {
      'ENFP': ['INFJ', 'INTJ', 'ENFP', 'ENTP'],
      'ENFJ': ['INFP', 'ISFP', 'ENFJ', 'ENTJ'],
      'ENTP': ['INFJ', 'INTJ', 'ENFP', 'ENTP'],
      'ENTJ': ['INFP', 'ISFP', 'ENFJ', 'ENTJ'],
      'INFP': ['ENFJ', 'ENTJ', 'INFP', 'ISFP'],
      'INFJ': ['ENFP', 'ENTP', 'INFJ', 'INTJ'],
      'ISFP': ['ENFJ', 'ENTJ', 'INFP', 'ISFP'],
      'INTJ': ['ENFP', 'ENTP', 'INFJ', 'INTJ'],
      'ESFP': ['ISFJ', 'ISTJ', 'ESFP', 'ESTP'],
      'ESFJ': ['ISTP', 'ISFP', 'ESFJ', 'ESTJ'],
      'ESTP': ['ISFJ', 'ISTJ', 'ESFP', 'ESTP'],
      'ESTJ': ['ISTP', 'ISFP', 'ESFJ', 'ESTJ'],
      'ISFJ': ['ESFP', 'ESTP', 'ISFJ', 'ISTJ'],
      'ISTJ': ['ESFP', 'ESTP', 'ISFJ', 'ISTJ'],
      'ISTP': ['ESFJ', 'ESTJ', 'ISTP', 'ISFP'],
    };

    return compatiblePairs[myMbti]?.contains(targetMbti) ?? false;
  }

  /// 연령대 호환성 확인
  bool isCompatibleAge(int myAge, int targetAge, {int tolerance = 5}) {
    return (myAge - targetAge).abs() <= tolerance;
  }
}

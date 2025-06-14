import '../models/api/analysis_models.dart';
import '../network/api_client.dart';
import '../services/auth_service.dart';
import '../errors/exceptions.dart';

class AnalysisService {
  static AnalysisService? _instance;
  factory AnalysisService() => _instance ??= AnalysisService._internal();
  AnalysisService._internal();

  final ApiClient _apiClient = ApiClient();
  final AuthService _authService = AuthService();

  /// 일기 AI 분석 요청
  Future<DiaryAnalysisResponse> analyzeDiary({
    required String diaryId,
    required String content,
    DiaryMetadata? metadata,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = DiaryAnalysisRequest(
        diaryId: diaryId,
        content: content,
        metadata: metadata,
      );

      return await _apiClient.analysisApi.analyzeDiary(
        headers['Authorization']!,
        request,
      );
    } catch (e) {
      throw ApiException('일기 분석 요청 실패: $e');
    }
  }

  /// 분석 결과 조회
  Future<DiaryAnalysisResponse> getAnalysisResult(String diaryId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getAnalysisResult(
        headers['Authorization']!,
        diaryId,
      );
    } catch (e) {
      throw ApiException('분석 결과 조회 실패: $e');
    }
  }

  /// 사용자 감정 패턴 조회
  Future<UserEmotionPatterns> getEmotionPatterns(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getEmotionPatterns(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('감정 패턴 조회 실패: $e');
    }
  }

  /// 사용자 성격 분석 결과 조회
  Future<Map<String, dynamic>> getPersonalityAnalysis(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getPersonalityAnalysis(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('성격 분석 조회 실패: $e');
    }
  }

  /// 사용자 종합 인사이트 조회
  Future<Map<String, dynamic>> getOverallInsights(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getOverallInsights(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('종합 인사이트 조회 실패: $e');
    }
  }

  /// 분석 이력 조회
  Future<AnalysisHistoryResponse> getAnalysisHistory({
    required String userId,
    int? limit,
    int? offset,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getAnalysisHistory(
        headers['Authorization']!,
        userId,
        limit,
        offset,
      );
    } catch (e) {
      throw ApiException('분석 이력 조회 실패: $e');
    }
  }

  /// 분석 결과 삭제
  Future<void> deleteAnalysisResult(String diaryId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      await _apiClient.analysisApi.deleteAnalysisResult(
        headers['Authorization']!,
        diaryId,
      );
    } catch (e) {
      throw ApiException('분석 결과 삭제 실패: $e');
    }
  }

  /// 분석 통계 조회
  Future<Map<String, dynamic>> getAnalysisStats(String userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      return await _apiClient.analysisApi.getAnalysisStats(
        headers['Authorization']!,
        userId,
      );
    } catch (e) {
      throw ApiException('분석 통계 조회 실패: $e');
    }
  }

  /// 일기 메타데이터 생성 도우미
  DiaryMetadata createMetadata({
    String? date,
    String? weather,
    String? moodBefore,
    List<String>? activities,
    String? location,
  }) {
    return DiaryMetadata(
      date: date ?? DateTime.now().toIso8601String().split('T')[0],
      weather: weather,
      moodBefore: moodBefore,
      activities: activities,
      location: location,
    );
  }

  /// 감정 점수를 텍스트로 변환
  String sentimentScoreToText(double score) {
    if (score >= 0.7) return '매우 긍정적';
    if (score >= 0.3) return '긍정적';
    if (score >= -0.3) return '중립적';
    if (score >= -0.7) return '부정적';
    return '매우 부정적';
  }

  /// MBTI 신뢰도를 텍스트로 변환
  String confidenceLevelToText(double confidence) {
    if (confidence >= 0.8) return '높음';
    if (confidence >= 0.6) return '보통';
    return '낮음';
  }
}

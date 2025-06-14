import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/api/analysis_models.dart';

part 'analysis_api.g.dart';

@RestApi()
abstract class AnalysisApi {
  factory AnalysisApi(Dio dio, {String baseUrl}) = _AnalysisApi;

  /// 일기 텍스트 AI 분석
  @POST('/api/v1/analysis/diary')
  Future<DiaryAnalysisResponse> analyzeDiary(
    @Header('Authorization') String token,
    @Body() DiaryAnalysisRequest request,
  );

  /// 분석 결과 조회
  @GET('/api/v1/analysis/diary/{diaryId}')
  Future<DiaryAnalysisResponse> getAnalysisResult(
    @Header('Authorization') String token,
    @Path('diaryId') String diaryId,
  );

  /// 사용자 감정 패턴 조회
  @GET('/api/v1/analysis/emotions/{userId}')
  Future<UserEmotionPatterns> getEmotionPatterns(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );

  /// 사용자 성격 분석 결과 조회
  @GET('/api/v1/analysis/personality/{userId}')
  Future<Map<String, dynamic>> getPersonalityAnalysis(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );

  /// 사용자 종합 인사이트 조회
  @GET('/api/v1/analysis/insights/{userId}')
  Future<Map<String, dynamic>> getOverallInsights(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );

  /// 분석 이력 조회
  @GET('/api/v1/analysis/history/{userId}')
  Future<AnalysisHistoryResponse> getAnalysisHistory(
    @Header('Authorization') String token,
    @Path('userId') String userId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  /// 분석 결과 삭제
  @DELETE('/api/v1/analysis/diary/{diaryId}')
  Future<Map<String, dynamic>> deleteAnalysisResult(
    @Header('Authorization') String token,
    @Path('diaryId') String diaryId,
  );

  /// 분석 통계 조회
  @GET('/api/v1/analysis/stats/{userId}')
  Future<Map<String, dynamic>> getAnalysisStats(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/api/matching_models.dart';

part 'matching_api.g.dart';

@RestApi()
abstract class MatchingApi {
  factory MatchingApi(Dio dio, {String baseUrl}) = _MatchingApi;

  /// 매칭 후보 추천
  @POST('/api/v1/matching/candidates')
  Future<MatchingCandidatesResponse> getMatchingCandidates(
    @Header('Authorization') String token,
    @Body() MatchingCandidatesRequest request,
  );

  /// 호환성 점수 계산
  @POST('/api/v1/matching/compatibility')
  Future<CompatibilityResponse> calculateCompatibility(
    @Header('Authorization') String token,
    @Body() CompatibilityRequest request,
  );

  /// 매칭용 사용자 프로필 조회
  @GET('/api/v1/matching/profile/{userId}')
  Future<MatchingUserProfile> getMatchingProfile(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );

  /// 매칭 선호도 설정 업데이트
  @PUT('/api/v1/matching/preferences')
  Future<BaseResponse> updateMatchingPreferences(
    @Header('Authorization') String token,
    @Body() UpdatePreferencesRequest request,
  );

  /// 매칭 선호도 설정 조회
  @GET('/api/v1/matching/preferences')
  Future<Map<String, dynamic>> getMatchingPreferences(
    @Header('Authorization') String token,
  );

  /// 매칭 이력 조회
  @GET('/api/v1/matching/history')
  Future<Map<String, dynamic>> getMatchingHistory(
    @Header('Authorization') String token,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  /// 매칭 피드백 제출
  @POST('/api/v1/matching/feedback')
  Future<BaseResponse> submitMatchingFeedback(
    @Header('Authorization') String token,
    @Body() MatchingFeedbackRequest request,
  );

  /// 매칭 분석 데이터 조회
  @GET('/api/v1/matching/analytics/{userId}')
  Future<Map<String, dynamic>> getMatchingAnalytics(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );
}

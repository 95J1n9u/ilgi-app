import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/api/auth_models.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  /// Firebase 토큰 검증 및 내부 JWT 발급
  @POST('/api/v1/auth/verify-token')
  Future<TokenVerificationResponse> verifyToken(
    @Header('Authorization') String firebaseToken,
  );

  /// 토큰 갱신
  @POST('/api/v1/auth/refresh')
  Future<TokenVerificationResponse> refreshToken(
    @Header('Authorization') String currentToken,
  );

  /// 현재 사용자 정보 조회
  @GET('/api/v1/auth/me')
  Future<UserInfo> getCurrentUser(
    @Header('Authorization') String token,
  );

  /// 로그아웃
  @POST('/api/v1/auth/logout')
  Future<LogoutResponse> logout(
    @Header('Authorization') String token,
  );

  /// 토큰 유효성 검증
  @GET('/api/v1/auth/validate')
  Future<TokenValidationResponse> validateToken(
    @Header('Authorization') String token,
  );
}

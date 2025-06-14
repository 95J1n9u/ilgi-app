import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Firebase 토큰 검증 및 JWT 발급 요청
@JsonSerializable()
class TokenVerificationRequest {
  @JsonKey(name: 'firebase_token')
  final String firebaseToken;

  const TokenVerificationRequest({
    required this.firebaseToken,
  });

  factory TokenVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenVerificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TokenVerificationRequestToJson(this);
}

/// 토큰 검증 응답
@JsonSerializable()
class TokenVerificationResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'user_info')
  final UserInfo userInfo;

  const TokenVerificationResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userInfo,
  });

  factory TokenVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenVerificationResponseToJson(this);
}

/// 사용자 정보
@JsonSerializable()
class UserInfo {
  final String uid;
  final String email;
  final String name;
  final String? picture;

  @JsonKey(name: 'email_verified')
  final bool emailVerified;

  const UserInfo({
    required this.uid,
    required this.email,
    required this.name,
    this.picture,
    required this.emailVerified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

/// 토큰 유효성 검증 응답
@JsonSerializable()
class TokenValidationResponse {
  final bool valid;

  @JsonKey(name: 'user_id')
  final String userId;

  final String email;

  const TokenValidationResponse({
    required this.valid,
    required this.userId,
    required this.email,
  });

  factory TokenValidationResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenValidationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenValidationResponseToJson(this);
}

/// 로그아웃 응답
@JsonSerializable()
class LogoutResponse {
  final String message;
  final String detail;

  const LogoutResponse({
    required this.message,
    required this.detail,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}

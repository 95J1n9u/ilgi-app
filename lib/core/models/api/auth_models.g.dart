// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenVerificationRequest _$TokenVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    TokenVerificationRequest(
      firebaseToken: json['firebase_token'] as String,
    );

Map<String, dynamic> _$TokenVerificationRequestToJson(
        TokenVerificationRequest instance) =>
    <String, dynamic>{
      'firebase_token': instance.firebaseToken,
    };

TokenVerificationResponse _$TokenVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    TokenVerificationResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenVerificationResponseToJson(
        TokenVerificationResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user_info': instance.userInfo.toJson(),
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      picture: json['picture'] as String?,
      emailVerified: json['email_verified'] as bool,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'email': instance.email,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('picture', instance.picture);
  val['email_verified'] = instance.emailVerified;
  return val;
}

TokenValidationResponse _$TokenValidationResponseFromJson(
        Map<String, dynamic> json) =>
    TokenValidationResponse(
      valid: json['valid'] as bool,
      userId: json['user_id'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$TokenValidationResponseToJson(
        TokenValidationResponse instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'user_id': instance.userId,
      'email': instance.email,
    };

LogoutResponse _$LogoutResponseFromJson(Map<String, dynamic> json) =>
    LogoutResponse(
      message: json['message'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$LogoutResponseToJson(LogoutResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'detail': instance.detail,
    };

import 'package:json_annotation/json_annotation.dart';

part 'common_models.g.dart';

/// API 에러 응답
@JsonSerializable()
class ApiErrorResponse {
  final String error;
  final String message;

  @JsonKey(name: 'status_code')
  final int statusCode;

  final dynamic details;

  const ApiErrorResponse({
    required this.error,
    required this.message,
    required this.statusCode,
    this.details,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);
}

/// 헬스체크 응답
@JsonSerializable()
class HealthCheckResponse {
  final String status;

  @JsonKey(name: 'app_name')
  final String appName;

  final String version;
  final String environment;

  const HealthCheckResponse({
    required this.status,
    required this.appName,
    required this.version,
    required this.environment,
  });

  factory HealthCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HealthCheckResponseToJson(this);
}

/// 루트 엔드포인트 응답
@JsonSerializable()
class RootResponse {
  final String message;
  final String version;
  final String docs;
  final String health;

  const RootResponse({
    required this.message,
    required this.version,
    required this.docs,
    required this.health,
  });

  factory RootResponse.fromJson(Map<String, dynamic> json) =>
      _$RootResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RootResponseToJson(this);
}

/// 기본 성공 응답
@JsonSerializable()
class SuccessResponse {
  final String message;
  final bool success;
  final dynamic data;

  const SuccessResponse({
    required this.message,
    this.success = true,
    this.data,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseToJson(this);
}

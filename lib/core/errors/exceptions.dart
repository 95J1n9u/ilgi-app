/// 기본 애플리케이션 예외
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

/// API 관련 예외
class ApiException extends AppException {
  final int? statusCode;
  final String? endpoint;

  const ApiException(
    String message, {
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );

  factory ApiException.fromDioError(dynamic error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      
      String message = '서버 오류가 발생했습니다';
      String? code;
      
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
        code = data['error'] ?? data['code'];
      }
      
      return ApiException(
        message,
        statusCode: statusCode,
        code: code,
        details: data,
      );
    } else if (error.type.name == 'connectTimeout') {
      return const ApiException(
        '연결 시간이 초과되었습니다',
        code: 'CONNECT_TIMEOUT',
      );
    } else if (error.type.name == 'receiveTimeout') {
      return const ApiException(
        '응답 시간이 초과되었습니다',
        code: 'RECEIVE_TIMEOUT',
      );
    } else if (error.type.name == 'sendTimeout') {
      return const ApiException(
        '요청 전송 시간이 초과되었습니다',
        code: 'SEND_TIMEOUT',
      );
    } else {
      return ApiException(
        '네트워크 오류가 발생했습니다: ${error.message}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  factory ApiException.unauthorized() {
    return const ApiException(
      '인증이 필요합니다',
      statusCode: 401,
      code: 'UNAUTHORIZED',
    );
  }

  factory ApiException.forbidden() {
    return const ApiException(
      '접근 권한이 없습니다',
      statusCode: 403,
      code: 'FORBIDDEN',
    );
  }

  factory ApiException.notFound() {
    return const ApiException(
      '요청한 리소스를 찾을 수 없습니다',
      statusCode: 404,
      code: 'NOT_FOUND',
    );
  }

  factory ApiException.serverError() {
    return const ApiException(
      '서버 내부 오류가 발생했습니다',
      statusCode: 500,
      code: 'SERVER_ERROR',
    );
  }
}

/// 데이터베이스 관련 예외
class DatabaseException extends AppException {
  const DatabaseException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );
}

/// 캐시 관련 예외
class CacheException extends AppException {
  const CacheException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );
}

/// 파일 관련 예외
class FileException extends AppException {
  const FileException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );
}

/// 유효성 검사 예외
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    String message, {
    this.fieldErrors,
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );

  factory ValidationException.fromFieldErrors(Map<String, List<String>> fieldErrors) {
    return ValidationException(
      '입력값이 올바르지 않습니다',
      fieldErrors: fieldErrors,
      code: 'VALIDATION_ERROR',
    );
  }
}

/// 권한 관련 예외
class PermissionException extends AppException {
  final String permissionName;

  const PermissionException(
    String message, {
    required this.permissionName,
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );
}

/// 비즈니스 로직 예외
class BusinessException extends AppException {
  const BusinessException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );
}

/// 분석 관련 예외
class AnalysisException extends AppException {
  const AnalysisException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );

  factory AnalysisException.notReady() {
    return const AnalysisException(
      'AI 분석 서비스가 준비되지 않았습니다',
      code: 'ANALYSIS_NOT_READY',
    );
  }

  factory AnalysisException.insufficientData() {
    return const AnalysisException(
      '분석을 위한 데이터가 부족합니다',
      code: 'INSUFFICIENT_DATA',
    );
  }

  factory AnalysisException.processingFailed() {
    return const AnalysisException(
      'AI 분석 처리 중 오류가 발생했습니다',
      code: 'PROCESSING_FAILED',
    );
  }
}

/// 매칭 관련 예외
class MatchingException extends AppException {
  const MatchingException(
    String message, {
    String? code,
    dynamic details,
  }) : super(
          message: message,
          code: code,
          details: details,
        );

  factory MatchingException.profileIncomplete() {
    return const MatchingException(
      '매칭을 위해 프로필을 완성해주세요',
      code: 'PROFILE_INCOMPLETE',
    );
  }

  factory MatchingException.noCandidates() {
    return const MatchingException(
      '조건에 맞는 매칭 후보가 없습니다',
      code: 'NO_CANDIDATES',
    );
  }

  factory MatchingException.alreadyMatched() {
    return const MatchingException(
      '이미 매칭된 사용자입니다',
      code: 'ALREADY_MATCHED',
    );
  }
}

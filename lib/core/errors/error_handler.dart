import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'exceptions.dart';
import 'auth_exceptions.dart';

/// 전역 에러 핸들러
class ErrorHandler {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  /// 에러를 적절한 AppException으로 변환
  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    // 로그 기록
    _logError(error, stackTrace);

    // 이미 AppException인 경우 그대로 반환
    if (error is AppException) {
      return error;
    }

    // DioException 처리
    if (error is DioException) {
      return _handleDioError(error);
    }

    // AuthException 처리
    if (error is AuthException) {
      return ApiException(error.message, code: 'AUTH_ERROR');
    }

    // 기타 Exception 처리
    if (error is Exception) {
      return _handleGenericException(error);
    }

    // 알 수 없는 에러
    return ApiException(
      '알 수 없는 오류가 발생했습니다: ${error.toString()}',
      code: 'UNKNOWN_ERROR',
    );
  }

  /// DioException을 ApiException으로 변환
  static ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          '연결 시간이 초과되었습니다',
          code: 'CONNECTION_TIMEOUT',
        );

      case DioExceptionType.sendTimeout:
        return const ApiException(
          '요청 전송 시간이 초과되었습니다',
          code: 'SEND_TIMEOUT',
        );

      case DioExceptionType.receiveTimeout:
        return const ApiException(
          '응답 시간이 초과되었습니다',
          code: 'RECEIVE_TIMEOUT',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const ApiException(
          '요청이 취소되었습니다',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          '인터넷 연결을 확인해주세요',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          '보안 인증서에 문제가 있습니다',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        return ApiException(
          '네트워크 오류가 발생했습니다: ${error.message}',
          code: 'UNKNOWN_NETWORK_ERROR',
        );
    }
  }

  /// HTTP 응답 에러 처리
  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = '서버 오류가 발생했습니다';
    String? code;

    // 서버에서 보낸 에러 메시지 파싱
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      code = data['error'] ?? data['code'];
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message.isEmpty ? '잘못된 요청입니다' : message,
          statusCode: statusCode,
          code: code ?? 'BAD_REQUEST',
        );

      case 401:
        return ApiException(
          '인증이 필요합니다',
          statusCode: statusCode,
          code: code ?? 'UNAUTHORIZED',
        );

      case 403:
        return ApiException(
          '접근 권한이 없습니다',
          statusCode: statusCode,
          code: code ?? 'FORBIDDEN',
        );

      case 404:
        return ApiException(
          '요청한 리소스를 찾을 수 없습니다',
          statusCode: statusCode,
          code: code ?? 'NOT_FOUND',
        );

      case 422:
        return ValidationException(
          message.isEmpty ? '입력값이 올바르지 않습니다' : message,
          code: code ?? 'VALIDATION_ERROR',
          details: data,
        );

      case 429:
        return ApiException(
          '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요',
          statusCode: statusCode,
          code: code ?? 'TOO_MANY_REQUESTS',
        );

      case 500:
        return ApiException(
          '서버 내부 오류가 발생했습니다',
          statusCode: statusCode,
          code: code ?? 'INTERNAL_SERVER_ERROR',
        );

      case 502:
        return ApiException(
          '서버가 일시적으로 사용할 수 없습니다',
          statusCode: statusCode,
          code: code ?? 'BAD_GATEWAY',
        );

      case 503:
        return ApiException(
          '서비스가 일시적으로 중단되었습니다',
          statusCode: statusCode,
          code: code ?? 'SERVICE_UNAVAILABLE',
        );

      default:
        return ApiException(
          message,
          statusCode: statusCode,
          code: code ?? 'HTTP_ERROR',
        );
    }
  }

  /// 일반 Exception 처리
  static AppException _handleGenericException(Exception error) {
    final message = error.toString();

    // FormatException 처리
    if (error is FormatException) {
      return ApiException(
        '데이터 형식이 올바르지 않습니다',
        code: 'FORMAT_ERROR',
        details: message,
      );
    }

    // TypeError 처리
    if (error is TypeError) {
      return ApiException(
        '데이터 타입 오류가 발생했습니다',
        code: 'TYPE_ERROR',
        details: message,
      );
    }

    // 기타 Exception
    return ApiException(
      message.contains('Exception:') 
        ? message.replaceFirst('Exception: ', '')
        : message,
      code: 'GENERAL_ERROR',
    );
  }

  /// 에러 로그 기록
  static void _logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      if (error is DioException) {
        _logger.e(
          'API Error: ${error.type.name}',
          error: error,
          stackTrace: stackTrace,
        );
        
        if (error.response != null) {
          _logger.d('Response Status: ${error.response?.statusCode}');
          _logger.d('Response Data: ${error.response?.data}');
          _logger.d('Request URL: ${error.requestOptions.uri}');
          _logger.d('Request Method: ${error.requestOptions.method}');
          _logger.d('Request Headers: ${error.requestOptions.headers}');
        }
      } else {
        _logger.e(
          'Error: ${error.runtimeType}',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// 사용자 친화적 에러 메시지 생성
  static String getUserFriendlyMessage(AppException exception) {
    // 특정 에러 코드에 대한 사용자 친화적 메시지
    switch (exception.code) {
      case 'CONNECTION_TIMEOUT':
      case 'SEND_TIMEOUT':
      case 'RECEIVE_TIMEOUT':
        return '네트워크 연결이 불안정합니다. 다시 시도해주세요.';

      case 'CONNECTION_ERROR':
        return '인터넷 연결을 확인하고 다시 시도해주세요.';

      case 'UNAUTHORIZED':
        return '로그인이 필요합니다.';

      case 'FORBIDDEN':
        return '이 기능에 접근할 권한이 없습니다.';

      case 'NOT_FOUND':
        return '요청한 정보를 찾을 수 없습니다.';

      case 'VALIDATION_ERROR':
        return '입력하신 정보를 다시 확인해주세요.';

      case 'TOO_MANY_REQUESTS':
        return '잠시 후 다시 시도해주세요.';

      case 'INTERNAL_SERVER_ERROR':
      case 'BAD_GATEWAY':
      case 'SERVICE_UNAVAILABLE':
        return '서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요.';

      case 'ANALYSIS_NOT_READY':
        return 'AI 분석 기능이 준비되지 않았습니다.';

      case 'INSUFFICIENT_DATA':
        return '분석하기에 충분한 데이터가 없습니다.';

      case 'PROFILE_INCOMPLETE':
        return '프로필을 완성한 후 이용해주세요.';

      case 'NO_CANDIDATES':
        return '조건에 맞는 상대를 찾을 수 없습니다. 조건을 조정해보세요.';

      default:
        return exception.message;
    }
  }

  /// 에러 심각도 판단
  static ErrorSeverity getErrorSeverity(AppException exception) {
    switch (exception.code) {
      case 'UNAUTHORIZED':
      case 'FORBIDDEN':
      case 'INTERNAL_SERVER_ERROR':
        return ErrorSeverity.critical;

      case 'CONNECTION_ERROR':
      case 'CONNECTION_TIMEOUT':
      case 'SERVICE_UNAVAILABLE':
        return ErrorSeverity.high;

      case 'VALIDATION_ERROR':
      case 'NOT_FOUND':
      case 'TOO_MANY_REQUESTS':
        return ErrorSeverity.medium;

      default:
        return ErrorSeverity.low;
    }
  }

  /// 에러 복구 제안
  static List<String> getRecoveryActions(AppException exception) {
    switch (exception.code) {
      case 'CONNECTION_ERROR':
      case 'CONNECTION_TIMEOUT':
        return [
          '인터넷 연결 확인',
          'Wi-Fi 또는 모바일 데이터 재연결',
          '잠시 후 다시 시도',
        ];

      case 'UNAUTHORIZED':
        return [
          '다시 로그인',
          '계정 정보 확인',
        ];

      case 'VALIDATION_ERROR':
        return [
          '입력 정보 재확인',
          '필수 항목 입력',
        ];

      case 'PROFILE_INCOMPLETE':
        return [
          '프로필 완성하기',
          '필수 정보 입력',
        ];

      case 'NO_CANDIDATES':
        return [
          '검색 조건 완화',
          '관심사 추가',
          '나중에 다시 시도',
        ];

      default:
        return ['다시 시도하기'];
    }
  }
}

/// 에러 심각도
enum ErrorSeverity {
  low,    // 사용자가 쉽게 해결할 수 있음
  medium, // 일부 도움이나 재시도 필요
  high,   // 시스템 수준의 문제, 사용자 조치 어려움
  critical, // 즉시 해결 필요한 중대한 문제
}

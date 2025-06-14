import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../services/storage_service.dart';

class DioClient {
  late final Dio _dio;
  
  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': ApiConstants.contentType,
      },
    ));
    
    _setupInterceptors();
  }
  
  Dio get dio => _dio;
  
  void _setupInterceptors() {
    // 로깅 인터셉터
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));
    
    // 인증 인터셉터
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Firebase ID 토큰 자동 추가
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          try {
            final idToken = await user.getIdToken();
            options.headers[ApiConstants.authHeader] = 
                '${ApiConstants.bearerPrefix}$idToken';
          } catch (e) {
            print('토큰 가져오기 실패: $e');
          }
        }
        
        // 백엔드 JWT 토큰이 있다면 사용 (우선순위)
        final backendToken = await StorageService.getBackendToken();
        if (backendToken != null) {
          options.headers[ApiConstants.authHeader] = 
              '${ApiConstants.bearerPrefix}$backendToken';
        }
        
        handler.next(options);
      },
      
      onError: (error, handler) async {
        // 401 에러 시 토큰 갱신 시도
        if (error.response?.statusCode == 401) {
          try {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // 원래 요청 재시도
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          } catch (e) {
            print('토큰 갱신 실패: $e');
          }
        }
        
        handler.next(error);
      },
    ));
  }
  
  Future<bool> _refreshToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true); // 강제 갱신
        
        // 백엔드에서 새 JWT 토큰 발급
        final response = await _dio.post(
          '${ApiConstants.auth}/verify-token',
          options: Options(
            headers: {
              ApiConstants.authHeader: '${ApiConstants.bearerPrefix}$idToken'
            },
          ),
        );
        
        if (response.statusCode == 200) {
          final newToken = response.data['access_token'];
          await StorageService.saveBackendToken(newToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('토큰 갱신 중 오류: $e');
      return false;
    }
  }
}

// Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

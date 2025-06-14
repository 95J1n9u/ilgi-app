import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../services/auth_service.dart';
import 'apis/auth_api.dart';
import 'apis/analysis_api.dart';
import 'apis/matching_api.dart';

class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;
  late AuthApi _authApi;
  late AnalysisApi _analysisApi;
  late MatchingApi _matchingApi;

  ApiClient._internal() {
    _dio = Dio();
    _setupDio();
    _setupApis();
  }

  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Request Interceptor - 토큰 자동 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Authorization 헤더가 없으면 자동으로 추가
          if (!options.headers.containsKey('Authorization')) {
            final token = await AuthService().getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // 401 에러 시 토큰 갱신 시도
          if (error.response?.statusCode == 401) {
            try {
              final refreshed = await AuthService().refreshToken();
              if (refreshed) {
                // 토큰 갱신 성공 시 원래 요청 재시도
                final token = await AuthService().getAccessToken();
                if (token != null) {
                  error.requestOptions.headers['Authorization'] = 'Bearer $token';
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                }
              }
            } catch (e) {
              // 토큰 갱신 실패 시 로그아웃 처리
              await AuthService().logout();
            }
          }
          handler.next(error);
        },
      ),
    );

    // Response Interceptor - 로깅
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          // 개발 모드에서만 로그 출력
          if (ApiConstants.isDevelopment) {
            print(obj);
          }
        },
      ),
    );
  }

  void _setupApis() {
    _authApi = AuthApi(_dio, baseUrl: ApiConstants.baseUrl);
    _analysisApi = AnalysisApi(_dio, baseUrl: ApiConstants.baseUrl);
    _matchingApi = MatchingApi(_dio, baseUrl: ApiConstants.baseUrl);
  }

  // API Getters
  AuthApi get authApi => _authApi;
  AnalysisApi get analysisApi => _analysisApi;
  MatchingApi get matchingApi => _matchingApi;

  // Dio instance getter
  Dio get dio => _dio;

  // 인스턴스 초기화 (로그아웃 시 사용)
  void reset() {
    _instance = null;
  }
}

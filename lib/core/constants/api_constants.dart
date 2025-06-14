class ApiConstants {
  // 환경 설정
  static const bool isDevelopment = true; // 개발/운영 환경 구분
  
  // 기본 설정
  static const String baseUrlDev = 'http://localhost:8000'; // 개발용 (로컬 테스트)
  static const String baseUrlProd = 'https://ilgi-api-production.up.railway.app'; // 운영용 (Railway 배포)
  static String get baseUrl => isDevelopment ? baseUrlProd : baseUrlProd; // 현재는 운영 서버 사용
  
  static const String apiVersion = 'v1';
  static const String apiPath = '/api/$apiVersion';
  
  // 엔드포인트 경로
  static const String authPath = '/api/v1/auth';
  static const String analysisPath = '/api/v1/analysis';
  static const String matchingPath = '/api/v1/matching';
  
  // Auth 엔드포인트
  static const String verifyToken = '$authPath/verify-token';
  static const String refreshToken = '$authPath/refresh';
  static const String getCurrentUser = '$authPath/me';
  static const String logout = '$authPath/logout';
  static const String validateToken = '$authPath/validate';
  
  // Analysis 엔드포인트
  static const String analyzeDiary = '$analysisPath/diary';
  static const String getEmotionPatterns = '$analysisPath/emotions';
  static const String getPersonalityAnalysis = '$analysisPath/personality';
  static const String getOverallInsights = '$analysisPath/insights';
  static const String getAnalysisHistory = '$analysisPath/history';
  static const String getAnalysisStats = '$analysisPath/stats';
  
  // Matching 엔드포인트
  static const String getMatchingCandidates = '$matchingPath/candidates';
  static const String calculateCompatibility = '$matchingPath/compatibility';
  static const String getMatchingProfile = '$matchingPath/profile';
  static const String updatePreferences = '$matchingPath/preferences';
  static const String getMatchingHistory = '$matchingPath/history';
  static const String submitFeedback = '$matchingPath/feedback';
  static const String getMatchingAnalytics = '$matchingPath/analytics';
  
  // 헤더
  static const String contentType = 'application/json';
  static const String authHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  // 타임아웃
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Rate Limiting
  static const int maxRequestsPerMinute = 100;
  
  // 파일 업로드 제한
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxDiaryLength = 5000; // 5,000자
  
  // 캐시 설정
  static const Duration analysisResultCacheTtl = Duration(hours: 24);
  
  // Batch 설정
  static const int maxBatchSize = 10;
}

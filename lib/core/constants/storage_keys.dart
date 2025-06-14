class StorageKeys {
  // 인증 관련
  static const String accessToken = 'access_token';
  static const String tokenType = 'token_type';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String lastLoginTime = 'last_login_time';

  // 사용자 정보
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userProfileImage = 'user_profile_image';

  // 앱 설정
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String isFirstRun = 'is_first_run';
  static const String notificationEnabled = 'notification_enabled';

  // 일기 관련
  static const String lastDiaryDate = 'last_diary_date';
  static const String diaryDrafts = 'diary_drafts';
  static const String diaryBackupEnabled = 'diary_backup_enabled';

  // 매칭 관련
  static const String matchingPreferences = 'matching_preferences';
  static const String lastMatchingUpdate = 'last_matching_update';
  static const String swipeHistory = 'swipe_history';

  // 분석 관련
  static const String analysisCache = 'analysis_cache';
  static const String lastAnalysisUpdate = 'last_analysis_update';
  static const String personalityProfile = 'personality_profile';

  // FCM 관련
  static const String fcmToken = 'fcm_token';
  static const String lastFcmUpdate = 'last_fcm_update';

  // 캐시 관련
  static const String imageCacheSize = 'image_cache_size';
  static const String dataCacheEnabled = 'data_cache_enabled';
  static const String cacheExpiryTime = 'cache_expiry_time';

  // 개발/디버그
  static const String apiBaseUrl = 'api_base_url';
  static const String debugMode = 'debug_mode';
  static const String logLevel = 'log_level';
}

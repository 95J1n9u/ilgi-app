import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // 초기화
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // SharedPreferences getter
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService가 초기화되지 않았습니다. init()을 먼저 호출하세요.');
    }
    return _prefs!;
  }

  // 일반 데이터 저장/조회
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await prefs.clear();
  }

  // 보안 저장소 (민감한 데이터용)
  static Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> removeSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // 토큰 관리
  static Future<void> saveAccessToken(String token) async {
    await setSecureString('access_token', token);
  }

  static Future<String?> getAccessToken() async {
    return await getSecureString('access_token');
  }

  static Future<void> removeAccessToken() async {
    await removeSecureString('access_token');
  }

  static Future<void> saveRefreshToken(String token) async {
    await setSecureString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    return await getSecureString('refresh_token');
  }

  static Future<void> removeRefreshToken() async {
    await removeSecureString('refresh_token');
  }

  // 사용자 설정
  static Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    for (final entry in settings.entries) {
      if (entry.value is String) {
        await setString(entry.key, entry.value);
      } else if (entry.value is int) {
        await setInt(entry.key, entry.value);
      } else if (entry.value is bool) {
        await setBool(entry.key, entry.value);
      } else if (entry.value is List<String>) {
        await setStringList(entry.key, entry.value);
      }
    }
  }

  static Map<String, dynamic> getUserSettings(List<String> keys) {
    final Map<String, dynamic> settings = {};
    for (final key in keys) {
      final value = prefs.get(key);
      if (value != null) {
        settings[key] = value;
      }
    }
    return settings;
  }

  // 첫 실행 여부
  static bool isFirstRun() {
    return getBool('is_first_run') ?? true;
  }

  static Future<void> setFirstRunComplete() async {
    await setBool('is_first_run', false);
  }

  // 앱 테마 설정
  static String getThemeMode() {
    return getString('theme_mode') ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async {
    await setString('theme_mode', mode);
  }

  // 언어 설정
  static String getLanguage() {
    return getString('language') ?? 'ko';
  }

  static Future<void> setLanguage(String language) async {
    await setString('language', language);
  }

  // 알림 설정
  static bool isNotificationEnabled() {
    return getBool('notification_enabled') ?? true;
  }

  static Future<void> setNotificationEnabled(bool enabled) async {
    await setBool('notification_enabled', enabled);
  }

  // 온보딩 완료 여부
  static bool isOnboardingCompleted() {
    return getBool('onboarding_completed') ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    await setBool('onboarding_completed', true);
  }

  // 마지막 동기화 시간
  static DateTime? getLastSyncTime() {
    final timestamp = getInt('last_sync_timestamp');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static Future<void> setLastSyncTime(DateTime time) async {
    await setInt('last_sync_timestamp', time.millisecondsSinceEpoch);
  }
}

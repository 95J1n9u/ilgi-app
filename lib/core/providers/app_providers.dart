import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// App State Provider (전역 앱 상태)
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

class AppState {
  final bool isLoading;
  final String? error;
  final bool isOnline;

  const AppState({
    this.isLoading = false,
    this.error,
    this.isOnline = true,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    bool? isOnline,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setOnlineStatus(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }
}
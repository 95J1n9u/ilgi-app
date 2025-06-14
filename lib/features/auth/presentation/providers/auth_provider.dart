import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/api/auth_models.dart';
import '../../../../core/errors/auth_exceptions.dart';

// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 현재 사용자 스트림
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// 사용자 프로필 정보 Provider
final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  // Firestore에서 사용자 프로필 정보 가져오기
  try {
    final doc = await FirebaseService.usersCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  } catch (e) {
    throw Exception('사용자 정보를 가져올 수 없습니다: $e');
  }
});

// Auth State Notifier
class AuthState {
  final User? user;
  final UserModel? userProfile;
  final UserInfo? apiUserInfo;
  final String? accessToken;
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  const AuthState({
    this.user,
    this.userProfile,
    this.apiUserInfo,
    this.accessToken,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    UserModel? userProfile,
    UserInfo? apiUserInfo,
    String? accessToken,
    bool? isLoading,
    bool? isInitialized,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
      apiUserInfo: apiUserInfo ?? this.apiUserInfo,
      accessToken: accessToken ?? this.accessToken,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }

  bool get isAuthenticated => user != null && accessToken != null;
  bool get isEmailVerified => user?.emailVerified ?? false;
  bool get isApiConnected => apiUserInfo != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _initialize();
  }

  /// 인증 초기화 (앱 시작 시 호출)
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Firebase 인증 상태 감지
      _authService.authStateChanges.listen((user) async {
        if (user != null) {
          await _handleUserSignIn(user);
        } else {
          _handleUserSignOut();
        }
      });
      
      // 기존 인증 상태 확인
      final isInitialized = await _authService.initializeAuth();
      final currentUser = _authService.currentUser;
      
      if (currentUser != null && isInitialized) {
        await _loadUserData(currentUser);
      }
      
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: '초기화 실패: $e',
        isInitialized: true,
        isLoading: false,
      );
    }
  }

  /// 사용자 로그인 처리
  Future<void> _handleUserSignIn(User user) async {
    try {
      state = state.copyWith(user: user, isLoading: true);
      await _loadUserData(user);
    } catch (e) {
      state = state.copyWith(error: '사용자 데이터 로드 실패: $e');
    }
  }

  /// 사용자 로그아웃 처리
  void _handleUserSignOut() {
    state = const AuthState(isInitialized: true);
  }

  /// 사용자 데이터 로드 (Firebase + API)
  Future<void> _loadUserData(User user) async {
    try {
      // 1. Firestore에서 사용자 프로필 로드
      final doc = await FirebaseService.usersCollection.doc(user.uid).get();
      UserModel? userProfile;
      if (doc.exists) {
        userProfile = UserModel.fromFirestore(doc);
      }

      // 2. 백엔드 API 연동
      final tokenResponse = await _authService.verifyFirebaseToken();
      if (tokenResponse != null) {
        // 3. API에서 사용자 정보 조회
        final apiUserInfo = await _authService.getCurrentUserFromApi();
        
        state = state.copyWith(
          user: user,
          userProfile: userProfile,
          apiUserInfo: apiUserInfo,
          accessToken: tokenResponse.accessToken,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          user: user,
          userProfile: userProfile,
          isLoading: false,
          error: 'API 토큰 발급 실패',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: '사용자 데이터 로드 실패: $e',
        isLoading: false,
      );
    }
  }

  // 이메일 회원가입
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required DateTime birthDate,
    required String gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Firebase 회원가입
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        birthDate: birthDate,
        gender: gender,
      );
      
      // 회원가입 성공 시 자동으로 _handleUserSignIn이 호출됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 이메일 로그인
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Firebase 로그인
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      // 로그인 성공 시 자동으로 _handleUserSignIn이 호출됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Google 로그인
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Google 로그인
      await _authService.signInWithGoogle();
      
      // 로그인 성공 시 자동으로 _handleUserSignIn이 호출됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 로그아웃 (Firebase + 백엔드)
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // AuthService의 logout 메서드는 Firebase + 백엔드 로그아웃을 모두 처리
      await _authService.logout();
      
      // 로그아웃 성공 시 자동으로 _handleUserSignOut이 호출됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 비밀번호 재설정
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 이메일 인증 재전송
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // ========== API 연동 메서드들 ==========

  /// 토큰 갱신
  Future<void> refreshToken() async {
    try {
      final success = await _authService.refreshToken();
      if (success) {
        final newToken = await _authService.getAccessToken();
        state = state.copyWith(
          accessToken: newToken,
          error: null,
        );
      } else {
        state = state.copyWith(error: '토큰 갱신 실패');
      }
    } catch (e) {
      state = state.copyWith(error: '토큰 갱신 오류: $e');
    }
  }

  /// API 연결 상태 확인
  Future<void> checkApiConnection() async {
    try {
      final isValid = await _authService.validateToken();
      if (!isValid) {
        // 토큰이 유효하지 않으면 갱신 시도
        await refreshToken();
      }
    } catch (e) {
      state = state.copyWith(error: 'API 연결 확인 실패: $e');
    }
  }

  /// 에러 상태 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 인증 상태 재설정
  Future<void> resetAuthState() async {
    state = const AuthState();
    await _initialize();
  }
}

// AuthNotifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
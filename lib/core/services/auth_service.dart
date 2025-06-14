import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_service.dart';
import 'storage_service.dart';
import '../models/user_model.dart';
import '../models/api/auth_models.dart';
import '../errors/auth_exceptions.dart';
import '../network/api_client.dart';
import '../constants/storage_keys.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 현재 사용자
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // 인증 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 이메일 회원가입
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required DateTime birthDate,
    required String gender,
  }) async {
    try {
      // Firebase Auth 회원가입
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // 사용자 프로필 생성
        await _createUserProfile(
          userId: credential.user!.uid,
          email: email,
          name: name,
          birthDate: birthDate,
          gender: gender,
        );

        // 이메일 인증 전송
        await credential.user!.sendEmailVerification();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException('회원가입 중 오류가 발생했습니다: $e');
    }
  }

  // 이메일 로그인
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // FCM 토큰 업데이트
      await _updateFCMToken();

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException('로그인 중 오류가 발생했습니다: $e');
    }
  }

  // Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 트리거
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // 사용자가 로그인 취소
      }

      // Google Auth 세부정보 가져오기
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Firebase 인증 자격증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase로 로그인
      final userCredential = await _auth.signInWithCredential(credential);

      // 새 사용자인 경우 프로필 생성
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _createUserProfile(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? '사용자',
          profileImageUrl: userCredential.user!.photoURL,
        );
      }

      // FCM 토큰 업데이트
      await _updateFCMToken();

      return userCredential;
    } catch (e) {
      throw AuthException('Google 로그인 중 오류가 발생했습니다: $e');
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('로그아웃 중 오류가 발생했습니다: $e');
    }
  }

  // 비밀번호 재설정
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException('비밀번호 재설정 이메일 전송 실패: $e');
    }
  }

  // 사용자 프로필 생성
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String name,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  }) async {
    final userModel = UserModel(
      id: userId,
      email: email,
      name: name,
      birthDate: birthDate,
      gender: gender,
      profileImageUrl: profileImageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .set(userModel.toFirestore());
  }

  // FCM 토큰 업데이트
  Future<void> _updateFCMToken() async {
    if (currentUserId != null) {
      final fcmToken = await FirebaseService.getFCMToken();
      if (fcmToken != null) {
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .update({
          'fcmToken': fcmToken,
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // 이메일 인증 확인
  Future<bool> isEmailVerified() async {
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  // 이메일 인증 재전송
  Future<void> sendEmailVerification() async {
    if (currentUser != null && !currentUser!.emailVerified) {
      await currentUser!.sendEmailVerification();
    }
  }

  // ========== API 연동 메서드들 ==========

  static AuthService? _instance;
  factory AuthService() => _instance ??= AuthService._internal();
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  /// Firebase 토큰을 백엔드로 전송하여 JWT 토큰 발급
  Future<TokenVerificationResponse?> verifyFirebaseToken() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      // Firebase ID 토큰 가져오기
      final idToken = await user.getIdToken();
      
      // 백엔드 API 호출
      final response = await _apiClient.authApi.verifyToken('Bearer $idToken');
      
      // JWT 토큰 저장
      await _storageService.saveString(StorageKeys.accessToken, response.accessToken);
      await _storageService.saveString(StorageKeys.tokenType, response.tokenType);
      
      return response;
    } catch (e) {
      throw AuthException('토큰 검증 실패: $e');
    }
  }

  /// 저장된 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    return await _storageService.getString(StorageKeys.accessToken);
  }

  /// 토큰 갱신
  Future<bool> refreshToken() async {
    try {
      final currentToken = await getAccessToken();
      if (currentToken == null) return false;

      final response = await _apiClient.authApi.refreshToken('Bearer $currentToken');
      
      // 새 토큰 저장
      await _storageService.saveString(StorageKeys.accessToken, response.accessToken);
      await _storageService.saveString(StorageKeys.tokenType, response.tokenType);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 백엔드에서 현재 사용자 정보 조회
  Future<UserInfo?> getCurrentUserFromApi() async {
    try {
      final token = await getAccessToken();
      if (token == null) return null;

      return await _apiClient.authApi.getCurrentUser('Bearer $token');
    } catch (e) {
      throw AuthException('사용자 정보 조회 실패: $e');
    }
  }

  /// 토큰 유효성 검증
  Future<bool> validateToken() async {
    try {
      final token = await getAccessToken();
      if (token == null) return false;

      final response = await _apiClient.authApi.validateToken('Bearer $token');
      return response.valid;
    } catch (e) {
      return false;
    }
  }

  /// 로그아웃 (Firebase + 백엔드)
  Future<void> logout() async {
    try {
      // 백엔드 로그아웃 API 호출
      final token = await getAccessToken();
      if (token != null) {
        try {
          await _apiClient.authApi.logout('Bearer $token');
        } catch (e) {
          // 백엔드 로그아웃 실패해도 로컬 로그아웃은 진행
        }
      }

      // 로컬 토큰 삭제
      await _storageService.remove(StorageKeys.accessToken);
      await _storageService.remove(StorageKeys.tokenType);
      
      // Firebase 로그아웃
      await signOut();
      
      // API 클라이언트 리셋
      _apiClient.reset();
      
    } catch (e) {
      throw AuthException('로그아웃 실패: $e');
    }
  }

  /// 초기 인증 설정 (앱 시작 시 호출)
  Future<bool> initializeAuth() async {
    try {
      // Firebase 인증 상태 확인
      if (currentUser == null) return false;
      
      // 저장된 토큰 확인
      final token = await getAccessToken();
      if (token == null) {
        // 토큰이 없으면 새로 발급
        final result = await verifyFirebaseToken();
        return result != null;
      }
      
      // 토큰 유효성 검증
      final isValid = await validateToken();
      if (!isValid) {
        // 토큰이 유효하지 않으면 갱신 시도
        return await refreshToken();
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 인증된 API 호출을 위한 헤더 가져오기
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    if (token == null) {
      throw AuthException('인증 토큰이 없습니다');
    }
    
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}
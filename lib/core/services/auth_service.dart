import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';
import 'storage_service.dart';
import '../models/user_model.dart';
import '../models/api/auth_models.dart' hide UserInfo;
import '../models/api/auth_models.dart' as AuthModels;
import '../errors/auth_exceptions.dart';
import '../network/api_client.dart';
import '../constants/storage_keys.dart';

class AuthService {
  // 직접 Firebase 인스턴스 사용 (더 안전)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 사용자
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // 인증 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 이메일 회원가입 (단순화된 버전)
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required DateTime birthDate,
    required String gender,
  }) async {
    try {
      print('🔄 Firebase Auth 회원가입 시작: $email');
      
      // 단순한 Firebase Auth 회원가입
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth 성공: ${credential.user?.uid}');

      if (credential.user != null) {
        try {
          // 간단한 프로필 저장 시도
          await _firestore.collection('users').doc(credential.user!.uid).set({
            'email': email,
            'name': name,
            'birthDate': birthDate.toIso8601String(),
            'gender': gender,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
          print('✅ 프로필 저장 성공');
        } catch (e) {
          print('⚠️ 프로필 저장 실패 (무시): $e');
          // 프로필 저장 실패해도 계속 진행
        }

        // 이메일 인증 전송
        try {
          await credential.user!.sendEmailVerification();
          print('✅ 이메일 인증 전송 완료');
        } catch (e) {
          print('⚠️ 이메일 인증 전송 실패 (무시): $e');
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth 오류: ${e.code} - ${e.message}');
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      print('❌ 일반 오류: $e');
      throw AuthException('회원가입 중 오류가 발생했습니다: $e');
    }
  }

  // 이메일 로그인 (단순화된 버전)
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Firebase Auth 로그인 시작: $email');
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth 로그인 성공: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth 로그인 오류: ${e.code} - ${e.message}');
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      print('❌ 로그인 일반 오류: $e');
      throw AuthException('로그인 중 오류가 발생했습니다: $e');
    }
  }

  // 익명 로그인 (단순화된 버전)
  Future<UserCredential?> signInAnonymously() async {
    try {
      print('🔄 익명 로그인 시작');
      
      final credential = await _auth.signInAnonymously();
      
      print('✅ 익명 로그인 성공: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('❌ 익명 로그인 오류: ${e.code} - ${e.message}');
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      print('❌ 익명 로그인 일반 오류: $e');
      throw AuthException('익명 로그인 실패: ${e.toString()}');
    }
  }

  // 로그아웃 (단순화된 버전)
  Future<void> signOut() async {
    try {
      print('🔄 로그아웃 시작');
      await _auth.signOut();
      print('✅ 로그아웃 완료');
    } catch (e) {
      print('❌ 로그아웃 오류: $e');
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

  // ========== API 연동 메서드들 (기존 유지) ==========

  static AuthService? _instance;
  factory AuthService() => _instance ??= AuthService._internal();
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();

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
      await StorageService.setString(StorageKeys.accessToken, response.accessToken);
      await StorageService.setString(StorageKeys.tokenType, response.tokenType);
      
      return response;
    } catch (e) {
      throw AuthException('토큰 검증 실패: $e');
    }
  }

  /// 저장된 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    return StorageService.getString(StorageKeys.accessToken);
  }

  /// 토큰 갱신
  Future<bool> refreshToken() async {
    try {
      final currentToken = await getAccessToken();
      if (currentToken == null) return false;

      final response = await _apiClient.authApi.refreshToken('Bearer $currentToken');
      
      // 새 토큰 저장
      await StorageService.setString(StorageKeys.accessToken, response.accessToken);
      await StorageService.setString(StorageKeys.tokenType, response.tokenType);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 백엔드에서 현재 사용자 정보 조회
  Future<AuthModels.UserInfo?> getCurrentUserFromApi() async {
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
      await StorageService.remove(StorageKeys.accessToken);
      await StorageService.remove(StorageKeys.tokenType);
      
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
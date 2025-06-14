import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, [this.code]);

  factory AuthException.fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException('등록되지 않은 이메일입니다');
      case 'wrong-password':
        return const AuthException('비밀번호가 올바르지 않습니다');
      case 'invalid-email':
        return const AuthException('올바르지 않은 이메일 형식입니다');
      case 'user-disabled':
        return const AuthException('비활성화된 계정입니다');
      case 'email-already-in-use':
        return const AuthException('이미 사용 중인 이메일입니다');
      case 'weak-password':
        return const AuthException('비밀번호가 너무 약합니다');
      case 'operation-not-allowed':
        return const AuthException('허용되지 않은 작업입니다');
      case 'too-many-requests':
        return const AuthException('요청이 너무 많습니다. 잠시 후 다시 시도해주세요');
      case 'network-request-failed':
        return const AuthException('네트워크 연결을 확인해주세요');
      default:
        return AuthException('인증 오류가 발생했습니다: ${e.message}', e.code);
    }
  }

  @override
  String toString() => message;
}
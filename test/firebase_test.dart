import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../lib/core/services/firebase_service.dart';
import '../lib/core/services/auth_service.dart';

void main() {
  group('Firebase Service Tests', () {
    setUpAll(() async {
      // Firebase 테스트 초기화
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('Firebase 초기화 테스트', () async {
      // Firebase 서비스 초기화 테스트
      expect(FirebaseService.firestore, isNotNull);
      expect(FirebaseService.auth, isNotNull);
      expect(FirebaseService.storage, isNotNull);
    });

    test('Firestore 컬렉션 참조 테스트', () {
      expect(FirebaseService.usersCollection.path, equals('users'));
      expect(FirebaseService.diariesCollection.path, equals('diaries'));
      expect(FirebaseService.matchesCollection.path, equals('matches'));
    });
  });

  group('Auth Service Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('인증 상태 스트림 테스트', () {
      expect(authService.authStateChanges, isA<Stream<User?>>());
    });
  });
}
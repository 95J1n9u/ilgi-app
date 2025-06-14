import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  // Firebase 인스턴스들
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Getters
  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;
  static FirebaseMessaging get messaging => _messaging;

  // 현재 사용자
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;

  // 인증 상태 스트림
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore 컬렉션 참조
  static CollectionReference get usersCollection =>
      _firestore.collection('users');
  static CollectionReference get diariesCollection =>
      _firestore.collection('diaries');
  static CollectionReference get matchesCollection =>
      _firestore.collection('matches');
  static CollectionReference get chatRoomsCollection =>
      _firestore.collection('chatRooms');
  static CollectionReference get analysisCollection =>
      _firestore.collection('analysis');

  // Storage 참조
  static Reference get profileImagesRef =>
      _storage.ref().child('profile_images');
  static Reference get diaryAttachmentsRef =>
      _storage.ref().child('diary_attachments');
  static Reference get chatImagesRef =>
      _storage.ref().child('chat_images');

  // 초기화
  static Future<void> initialize() async {
    // FCM 토큰 가져오기
    await _requestNotificationPermission();

    // 포그라운드 메시지 핸들러 설정
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 백그라운드 메시지 핸들러 설정
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  // 알림 권한 요청
  static Future<void> _requestNotificationPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('알림 권한 상태: ${settings.authorizationStatus}');
  }

  // 포그라운드 메시지 처리
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('포그라운드 메시지 수신: ${message.messageId}');
    // 로컬 알림 표시 로직 추가
  }

  // 백그라운드 메시지 처리
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('백그라운드 메시지 수신: ${message.messageId}');
  }

  // FCM 토큰 가져오기
  static Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('FCM 토큰 가져오기 실패: $e');
      return null;
    }
  }

  // 서버 타임스탬프 가져오기
  static FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  // Firestore 트랜잭션 실행
  static Future<T> runTransaction<T>(
      Future<T> Function(Transaction transaction) updateFunction,
      ) {
    return _firestore.runTransaction(updateFunction);
  }

  // 배치 작업 실행
  static WriteBatch batch() => _firestore.batch();
}
// lib/features/test/test_firebase_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/firebase_service.dart';

class TestFirebasePage extends StatefulWidget {
  const TestFirebasePage({super.key});

  @override
  State<TestFirebasePage> createState() => _TestFirebasePageState();
}

class _TestFirebasePageState extends State<TestFirebasePage> {
  String _status = '테스트 준비 중...';

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      setState(() => _status = 'Firebase 연결 테스트 중...');

      // Firestore 쓰기 테스트
      await FirebaseService.firestore
          .collection('test')
          .doc('connection')
          .set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Firebase 연결 성공!',
      });

      // Firestore 읽기 테스트
      final doc = await FirebaseService.firestore
          .collection('test')
          .doc('connection')
          .get();

      if (doc.exists) {
        setState(() => _status = 'Firebase 연결 성공! ✅');
      } else {
        setState(() => _status = 'Firebase 연결 실패 ❌');
      }
    } catch (e) {
      setState(() => _status = 'Firebase 연결 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _testFirebaseConnection,
              child: const Text('다시 테스트'),
            ),
          ],
        ),
      ),
    );
  }
}
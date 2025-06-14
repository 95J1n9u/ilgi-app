import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/diary_repository.dart';
import '../../../../core/models/diary_model.dart';
import '../../../../core/services/firebase_service.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<DiaryModel>> getDiaries() async {
    final userId = FirebaseService.currentUserId;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('diaries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DiaryModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<DiaryModel?> getDiary(String id) async {
    final doc = await _firestore.collection('diaries').doc(id).get();
    if (doc.exists) {
      return DiaryModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<String> createDiary(DiaryModel diary) async {
    final docRef = await _firestore.collection('diaries').add(diary.toFirestore());
    return docRef.id;
  }

  @override
  Future<void> updateDiary(DiaryModel diary) async {
    await _firestore
        .collection('diaries')
        .doc(diary.id)
        .update(diary.toFirestore());
  }

  @override
  Future<void> deleteDiary(String id) async {
    await _firestore.collection('diaries').doc(id).delete();
  }

  @override
  Stream<List<DiaryModel>> watchDiaries() {
    final userId = FirebaseService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('diaries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DiaryModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<DiaryModel?> watchDiary(String id) {
    return _firestore
        .collection('diaries')
        .doc(id)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return DiaryModel.fromFirestore(doc);
      }
      return null;
    });
  }
}

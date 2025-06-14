import '../../../../core/models/diary_model.dart';

abstract class DiaryRepository {
  Future<List<DiaryModel>> getDiaries();
  Future<DiaryModel?> getDiary(String id);
  Future<String> createDiary(DiaryModel diary);
  Future<void> updateDiary(DiaryModel diary);
  Future<void> deleteDiary(String id);
  Stream<List<DiaryModel>> watchDiaries();
  Stream<DiaryModel?> watchDiary(String id);
}

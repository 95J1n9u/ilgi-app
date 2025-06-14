import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String id;
  final String userId;
  final String content;
  final String? title;
  final List<String> emotions;
  final String? mood;
  final String? weather;
  final String? location;
  final List<String> activities;
  final bool isPrivate;
  final String analysisStatus; // 'pending', 'processing', 'completed', 'failed'
  final Map<String, dynamic>? analysisResult;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiaryModel({
    required this.id,
    required this.userId,
    required this.content,
    this.title,
    this.emotions = const [],
    this.mood,
    this.weather,
    this.location,
    this.activities = const [],
    this.isPrivate = false,
    this.analysisStatus = 'pending',
    this.analysisResult,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'title': title,
      'emotions': emotions,
      'mood': mood,
      'weather': weather,
      'location': location,
      'activities': activities,
      'isPrivate': isPrivate,
      'analysisStatus': analysisStatus,
      'analysisResult': analysisResult,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore 저장용 (id 제외)
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'title': title,
      'emotions': emotions,
      'mood': mood,
      'weather': weather,
      'location': location,
      'activities': activities,
      'isPrivate': isPrivate,
      'analysisStatus': analysisStatus,
      'analysisResult': analysisResult,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // JSON에서 생성
  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      title: json['title'] as String?,
      emotions: List<String>.from(json['emotions'] ?? []),
      mood: json['mood'] as String?,
      weather: json['weather'] as String?,
      location: json['location'] as String?,
      activities: List<String>.from(json['activities'] ?? []),
      isPrivate: json['isPrivate'] as bool? ?? false,
      analysisStatus: json['analysisStatus'] as String? ?? 'pending',
      analysisResult: json['analysisResult'] as Map<String, dynamic>?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Firestore DocumentSnapshot에서 생성
  factory DiaryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DiaryModel.fromJson({...data, 'id': doc.id});
  }

  // copyWith 메서드
  DiaryModel copyWith({
    String? id,
    String? userId,
    String? content,
    String? title,
    List<String>? emotions,
    String? mood,
    String? weather,
    String? location,
    List<String>? activities,
    bool? isPrivate,
    String? analysisStatus,
    Map<String, dynamic>? analysisResult,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      title: title ?? this.title,
      emotions: emotions ?? this.emotions,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      location: location ?? this.location,
      activities: activities ?? this.activities,
      isPrivate: isPrivate ?? this.isPrivate,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      analysisResult: analysisResult ?? this.analysisResult,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 미리보기 텍스트 (최대 100자)
  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  // 분석 완료 여부
  bool get isAnalysisCompleted => analysisStatus == 'completed';
}
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime? birthDate;
  final String? gender;
  final String? profileImageUrl;
  final String? bio;
  final List<String> interests;
  final Map<String, dynamic>? personalityData;
  final Map<String, dynamic>? settings;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.birthDate,
    this.gender,
    this.profileImageUrl,
    this.bio,
    this.interests = const [],
    this.personalityData,
    this.settings,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'interests': interests,
      'personalityData': personalityData,
      'settings': settings ?? _defaultSettings,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  // Firestore 저장용 (id 제외)
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'interests': interests,
      'personalityData': personalityData,
      'settings': settings ?? _defaultSettings,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  // JSON에서 생성
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      gender: json['gender'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      interests: List<String>.from(json['interests'] ?? []),
      personalityData: json['personalityData'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
      fcmToken: json['fcmToken'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Firestore DocumentSnapshot에서 생성
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
  }

  // copyWith 메서드
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
    String? bio,
    List<String>? interests,
    Map<String, dynamic>? personalityData,
    Map<String, dynamic>? settings,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      personalityData: personalityData ?? this.personalityData,
      settings: settings ?? this.settings,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // 기본 설정
  static const Map<String, dynamic> _defaultSettings = {
    'notifications': {
      'matches': true,
      'messages': true,
      'diary_analysis': true,
    },
    'privacy': {
      'profile_visibility': 'public',
      'diary_analysis_consent': true,
      'location_sharing': false,
    },
    'preferences': {
      'theme': 'system',
      'language': 'ko',
    },
  };

  // 나이 계산
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}
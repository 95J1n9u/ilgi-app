import 'package:json_annotation/json_annotation.dart';

part 'matching_models.g.dart';

/// 매칭 후보 추천 요청
@JsonSerializable()
class MatchingCandidatesRequest {
  final int? limit;

  @JsonKey(name: 'min_compatibility')
  final double? minCompatibility;

  final MatchingFilters? filters;

  const MatchingCandidatesRequest({
    this.limit,
    this.minCompatibility,
    this.filters,
  });

  factory MatchingCandidatesRequest.fromJson(Map<String, dynamic> json) =>
      _$MatchingCandidatesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingCandidatesRequestToJson(this);
}

/// 매칭 필터
@JsonSerializable()
class MatchingFilters {
  @JsonKey(name: 'age_range')
  final List<int>? ageRange;

  final String? location;
  final List<String>? interests;

  @JsonKey(name: 'mbti_types')
  final List<String>? mbtiTypes;

  const MatchingFilters({
    this.ageRange,
    this.location,
    this.interests,
    this.mbtiTypes,
  });

  factory MatchingFilters.fromJson(Map<String, dynamic> json) =>
      _$MatchingFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingFiltersToJson(this);
}

/// 매칭 후보 응답
@JsonSerializable()
class MatchingCandidatesResponse {
  @JsonKey(name: 'user_id')
  final String userId;

  final List<MatchingCandidate> candidates;

  @JsonKey(name: 'total_count')
  final int totalCount;

  @JsonKey(name: 'filters_applied')
  final MatchingFilters? filtersApplied;

  const MatchingCandidatesResponse({
    required this.userId,
    required this.candidates,
    required this.totalCount,
    this.filtersApplied,
  });

  factory MatchingCandidatesResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchingCandidatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingCandidatesResponseToJson(this);
}

/// 매칭 후보
@JsonSerializable()
class MatchingCandidate {
  @JsonKey(name: 'candidate_id')
  final String candidateId;

  @JsonKey(name: 'compatibility_score')
  final double compatibilityScore;

  @JsonKey(name: 'shared_traits')
  final List<String> sharedTraits;

  @JsonKey(name: 'personality_match')
  final PersonalityMatch personalityMatch;

  @JsonKey(name: 'lifestyle_match')
  final LifestyleMatch lifestyleMatch;

  @JsonKey(name: 'profile_preview')
  final ProfilePreview profilePreview;

  const MatchingCandidate({
    required this.candidateId,
    required this.compatibilityScore,
    required this.sharedTraits,
    required this.personalityMatch,
    required this.lifestyleMatch,
    required this.profilePreview,
  });

  factory MatchingCandidate.fromJson(Map<String, dynamic> json) =>
      _$MatchingCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingCandidateToJson(this);
}

/// 성격 매칭 정보
@JsonSerializable()
class PersonalityMatch {
  @JsonKey(name: 'mbti_compatibility')
  final double mbtiCompatibility;

  @JsonKey(name: 'big5_similarity')
  final double big5Similarity;

  @JsonKey(name: 'communication_style')
  final String communicationStyle;

  const PersonalityMatch({
    required this.mbtiCompatibility,
    required this.big5Similarity,
    required this.communicationStyle,
  });

  factory PersonalityMatch.fromJson(Map<String, dynamic> json) =>
      _$PersonalityMatchFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityMatchToJson(this);
}

/// 라이프스타일 매칭 정보
@JsonSerializable()
class LifestyleMatch {
  @JsonKey(name: 'activity_overlap')
  final double activityOverlap;

  @JsonKey(name: 'value_alignment')
  final double valueAlignment;

  @JsonKey(name: 'social_pattern_fit')
  final double socialPatternFit;

  const LifestyleMatch({
    required this.activityOverlap,
    required this.valueAlignment,
    required this.socialPatternFit,
  });

  factory LifestyleMatch.fromJson(Map<String, dynamic> json) =>
      _$LifestyleMatchFromJson(json);

  Map<String, dynamic> toJson() => _$LifestyleMatchToJson(this);
}

/// 프로필 미리보기
@JsonSerializable()
class ProfilePreview {
  final int age;
  final String location;
  final List<String> interests;

  @JsonKey(name: 'personality_summary')
  final String personalitySummary;

  const ProfilePreview({
    required this.age,
    required this.location,
    required this.interests,
    required this.personalitySummary,
  });

  factory ProfilePreview.fromJson(Map<String, dynamic> json) =>
      _$ProfilePreviewFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePreviewToJson(this);
}

/// 호환성 점수 계산 요청
@JsonSerializable()
class CompatibilityRequest {
  @JsonKey(name: 'target_user_id')
  final String targetUserId;

  const CompatibilityRequest({
    required this.targetUserId,
  });

  factory CompatibilityRequest.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompatibilityRequestToJson(this);
}

/// 호환성 점수 응답
@JsonSerializable()
class CompatibilityResponse {
  @JsonKey(name: 'user_id_1')
  final String userId1;

  @JsonKey(name: 'user_id_2')
  final String userId2;

  @JsonKey(name: 'overall_compatibility')
  final double overallCompatibility;

  @JsonKey(name: 'compatibility_breakdown')
  final CompatibilityBreakdown compatibilityBreakdown;

  final List<String> strengths;

  @JsonKey(name: 'potential_challenges')
  final List<String> potentialChallenges;

  final List<String> recommendations;

  const CompatibilityResponse({
    required this.userId1,
    required this.userId2,
    required this.overallCompatibility,
    required this.compatibilityBreakdown,
    required this.strengths,
    required this.potentialChallenges,
    required this.recommendations,
  });

  factory CompatibilityResponse.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompatibilityResponseToJson(this);
}

/// 호환성 세부 분석
@JsonSerializable()
class CompatibilityBreakdown {
  @JsonKey(name: 'personality_compatibility')
  final double personalityCompatibility;

  @JsonKey(name: 'emotional_compatibility')
  final double emotionalCompatibility;

  @JsonKey(name: 'lifestyle_compatibility')
  final double lifestyleCompatibility;

  @JsonKey(name: 'communication_compatibility')
  final double communicationCompatibility;

  const CompatibilityBreakdown({
    required this.personalityCompatibility,
    required this.emotionalCompatibility,
    required this.lifestyleCompatibility,
    required this.communicationCompatibility,
  });

  factory CompatibilityBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$CompatibilityBreakdownToJson(this);
}

/// 매칭용 사용자 프로필
@JsonSerializable()
class MatchingUserProfile {
  @JsonKey(name: 'user_id')
  final String userId;

  final MatchingProfile profile;

  const MatchingUserProfile({
    required this.userId,
    required this.profile,
  });

  factory MatchingUserProfile.fromJson(Map<String, dynamic> json) =>
      _$MatchingUserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingUserProfileToJson(this);
}

/// 매칭 프로필
@JsonSerializable()
class MatchingProfile {
  @JsonKey(name: 'basic_info')
  final BasicInfo basicInfo;

  @JsonKey(name: 'personality_profile')
  final PersonalityProfile personalityProfile;

  @JsonKey(name: 'lifestyle_profile')
  final LifestyleProfile lifestyleProfile;

  @JsonKey(name: 'matching_preferences')
  final MatchingPreferences matchingPreferences;

  const MatchingProfile({
    required this.basicInfo,
    required this.personalityProfile,
    required this.lifestyleProfile,
    required this.matchingPreferences,
  });

  factory MatchingProfile.fromJson(Map<String, dynamic> json) =>
      _$MatchingProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingProfileToJson(this);
}

/// 기본 정보
@JsonSerializable()
class BasicInfo {
  final int age;
  final String location;
  final String occupation;

  const BasicInfo({
    required this.age,
    required this.location,
    required this.occupation,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) =>
      _$BasicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInfoToJson(this);
}

/// 성격 프로필
@JsonSerializable()
class PersonalityProfile {
  final String mbti;

  @JsonKey(name: 'big5_summary')
  final String big5Summary;

  @JsonKey(name: 'key_traits')
  final List<String> keyTraits;

  const PersonalityProfile({
    required this.mbti,
    required this.big5Summary,
    required this.keyTraits,
  });

  factory PersonalityProfile.fromJson(Map<String, dynamic> json) =>
      _$PersonalityProfileFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityProfileToJson(this);
}

/// 라이프스타일 프로필
@JsonSerializable()
class LifestyleProfile {
  final List<String> interests;
  final List<String> values;

  @JsonKey(name: 'activity_preferences')
  final List<String> activityPreferences;

  @JsonKey(name: 'communication_style')
  final String communicationStyle;

  const LifestyleProfile({
    required this.interests,
    required this.values,
    required this.activityPreferences,
    required this.communicationStyle,
  });

  factory LifestyleProfile.fromJson(Map<String, dynamic> json) =>
      _$LifestyleProfileFromJson(json);

  Map<String, dynamic> toJson() => _$LifestyleProfileToJson(this);
}

/// 매칭 선호도
@JsonSerializable()
class MatchingPreferences {
  @JsonKey(name: 'preferred_age_range')
  final List<int> preferredAgeRange;

  @JsonKey(name: 'preferred_mbti')
  final List<String> preferredMbti;

  @JsonKey(name: 'important_values')
  final List<String> importantValues;

  const MatchingPreferences({
    required this.preferredAgeRange,
    required this.preferredMbti,
    required this.importantValues,
  });

  factory MatchingPreferences.fromJson(Map<String, dynamic> json) =>
      _$MatchingPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingPreferencesToJson(this);
}

/// 매칭 선호도 업데이트 요청
@JsonSerializable()
class UpdatePreferencesRequest {
  @JsonKey(name: 'age_range')
  final List<int>? ageRange;

  @JsonKey(name: 'location_preference')
  final List<String>? locationPreference;

  @JsonKey(name: 'mbti_preferences')
  final List<String>? mbtiPreferences;

  @JsonKey(name: 'value_priorities')
  final List<String>? valuePriorities;

  @JsonKey(name: 'lifestyle_preferences')
  final LifestylePreferences? lifestylePreferences;

  const UpdatePreferencesRequest({
    this.ageRange,
    this.locationPreference,
    this.mbtiPreferences,
    this.valuePriorities,
    this.lifestylePreferences,
  });

  factory UpdatePreferencesRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferencesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePreferencesRequestToJson(this);
}

/// 라이프스타일 선호도
@JsonSerializable()
class LifestylePreferences {
  @JsonKey(name: 'activity_types')
  final List<String>? activityTypes;

  @JsonKey(name: 'social_frequency')
  final String? socialFrequency;

  @JsonKey(name: 'communication_style')
  final String? communicationStyle;

  const LifestylePreferences({
    this.activityTypes,
    this.socialFrequency,
    this.communicationStyle,
  });

  factory LifestylePreferences.fromJson(Map<String, dynamic> json) =>
      _$LifestylePreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$LifestylePreferencesToJson(this);
}

/// 매칭 피드백 요청
@JsonSerializable()
class MatchingFeedbackRequest {
  @JsonKey(name: 'match_id')
  final String matchId;

  @JsonKey(name: 'feedback_type')
  final String feedbackType;

  final int rating;
  final String? comments;

  @JsonKey(name: 'interaction_quality')
  final InteractionQuality? interactionQuality;

  const MatchingFeedbackRequest({
    required this.matchId,
    required this.feedbackType,
    required this.rating,
    this.comments,
    this.interactionQuality,
  });

  factory MatchingFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$MatchingFeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingFeedbackRequestToJson(this);
}

/// 상호작용 품질
@JsonSerializable()
class InteractionQuality {
  final int communication;
  final int compatibility;

  @JsonKey(name: 'interest_level')
  final int interestLevel;

  const InteractionQuality({
    required this.communication,
    required this.compatibility,
    required this.interestLevel,
  });

  factory InteractionQuality.fromJson(Map<String, dynamic> json) =>
      _$InteractionQualityFromJson(json);

  Map<String, dynamic> toJson() => _$InteractionQualityToJson(this);
}

/// 기본 API 응답
@JsonSerializable()
class BaseResponse {
  final String message;
  final String? status;

  const BaseResponse({
    required this.message,
    this.status,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}

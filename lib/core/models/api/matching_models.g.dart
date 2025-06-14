// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchingCandidatesRequest _$MatchingCandidatesRequestFromJson(
        Map<String, dynamic> json) =>
    MatchingCandidatesRequest(
      limit: json['limit'] as int?,
      minCompatibility: (json['min_compatibility'] as num?)?.toDouble(),
      filters: json['filters'] == null
          ? null
          : MatchingFilters.fromJson(json['filters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingCandidatesRequestToJson(
        MatchingCandidatesRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('limit', instance.limit);
  writeNotNull('min_compatibility', instance.minCompatibility);
  writeNotNull('filters', instance.filters?.toJson());
  return val;
}

MatchingFilters _$MatchingFiltersFromJson(Map<String, dynamic> json) =>
    MatchingFilters(
      ageRange: (json['age_range'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      location: json['location'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mbtiTypes: (json['mbti_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MatchingFiltersToJson(MatchingFilters instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('age_range', instance.ageRange);
  writeNotNull('location', instance.location);
  writeNotNull('interests', instance.interests);
  writeNotNull('mbti_types', instance.mbtiTypes);
  return val;
}

MatchingCandidatesResponse _$MatchingCandidatesResponseFromJson(
        Map<String, dynamic> json) =>
    MatchingCandidatesResponse(
      userId: json['user_id'] as String,
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => MatchingCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['total_count'] as int,
      filtersApplied: json['filters_applied'] == null
          ? null
          : MatchingFilters.fromJson(
              json['filters_applied'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingCandidatesResponseToJson(
        MatchingCandidatesResponse instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'candidates': instance.candidates.map((e) => e.toJson()).toList(),
    'total_count': instance.totalCount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filters_applied', instance.filtersApplied?.toJson());
  return val;
}

MatchingCandidate _$MatchingCandidateFromJson(Map<String, dynamic> json) =>
    MatchingCandidate(
      candidateId: json['candidate_id'] as String,
      compatibilityScore: (json['compatibility_score'] as num).toDouble(),
      sharedTraits: (json['shared_traits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      personalityMatch: PersonalityMatch.fromJson(
          json['personality_match'] as Map<String, dynamic>),
      lifestyleMatch: LifestyleMatch.fromJson(
          json['lifestyle_match'] as Map<String, dynamic>),
      profilePreview: ProfilePreview.fromJson(
          json['profile_preview'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingCandidateToJson(MatchingCandidate instance) =>
    <String, dynamic>{
      'candidate_id': instance.candidateId,
      'compatibility_score': instance.compatibilityScore,
      'shared_traits': instance.sharedTraits,
      'personality_match': instance.personalityMatch.toJson(),
      'lifestyle_match': instance.lifestyleMatch.toJson(),
      'profile_preview': instance.profilePreview.toJson(),
    };

PersonalityMatch _$PersonalityMatchFromJson(Map<String, dynamic> json) =>
    PersonalityMatch(
      mbtiCompatibility: (json['mbti_compatibility'] as num).toDouble(),
      big5Similarity: (json['big5_similarity'] as num).toDouble(),
      communicationStyle: json['communication_style'] as String,
    );

Map<String, dynamic> _$PersonalityMatchToJson(PersonalityMatch instance) =>
    <String, dynamic>{
      'mbti_compatibility': instance.mbtiCompatibility,
      'big5_similarity': instance.big5Similarity,
      'communication_style': instance.communicationStyle,
    };

LifestyleMatch _$LifestyleMatchFromJson(Map<String, dynamic> json) =>
    LifestyleMatch(
      activityOverlap: (json['activity_overlap'] as num).toDouble(),
      valueAlignment: (json['value_alignment'] as num).toDouble(),
      socialPatternFit: (json['social_pattern_fit'] as num).toDouble(),
    );

Map<String, dynamic> _$LifestyleMatchToJson(LifestyleMatch instance) =>
    <String, dynamic>{
      'activity_overlap': instance.activityOverlap,
      'value_alignment': instance.valueAlignment,
      'social_pattern_fit': instance.socialPatternFit,
    };

ProfilePreview _$ProfilePreviewFromJson(Map<String, dynamic> json) =>
    ProfilePreview(
      age: json['age'] as int,
      location: json['location'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      personalitySummary: json['personality_summary'] as String,
    );

Map<String, dynamic> _$ProfilePreviewToJson(ProfilePreview instance) =>
    <String, dynamic>{
      'age': instance.age,
      'location': instance.location,
      'interests': instance.interests,
      'personality_summary': instance.personalitySummary,
    };

CompatibilityRequest _$CompatibilityRequestFromJson(
        Map<String, dynamic> json) =>
    CompatibilityRequest(
      targetUserId: json['target_user_id'] as String,
    );

Map<String, dynamic> _$CompatibilityRequestToJson(
        CompatibilityRequest instance) =>
    <String, dynamic>{
      'target_user_id': instance.targetUserId,
    };

CompatibilityResponse _$CompatibilityResponseFromJson(
        Map<String, dynamic> json) =>
    CompatibilityResponse(
      userId1: json['user_id_1'] as String,
      userId2: json['user_id_2'] as String,
      overallCompatibility: (json['overall_compatibility'] as num).toDouble(),
      compatibilityBreakdown: CompatibilityBreakdown.fromJson(
          json['compatibility_breakdown'] as Map<String, dynamic>),
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      potentialChallenges: (json['potential_challenges'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CompatibilityResponseToJson(
        CompatibilityResponse instance) =>
    <String, dynamic>{
      'user_id_1': instance.userId1,
      'user_id_2': instance.userId2,
      'overall_compatibility': instance.overallCompatibility,
      'compatibility_breakdown': instance.compatibilityBreakdown.toJson(),
      'strengths': instance.strengths,
      'potential_challenges': instance.potentialChallenges,
      'recommendations': instance.recommendations,
    };

CompatibilityBreakdown _$CompatibilityBreakdownFromJson(
        Map<String, dynamic> json) =>
    CompatibilityBreakdown(
      personalityCompatibility:
          (json['personality_compatibility'] as num).toDouble(),
      emotionalCompatibility:
          (json['emotional_compatibility'] as num).toDouble(),
      lifestyleCompatibility:
          (json['lifestyle_compatibility'] as num).toDouble(),
      communicationCompatibility:
          (json['communication_compatibility'] as num).toDouble(),
    );

Map<String, dynamic> _$CompatibilityBreakdownToJson(
        CompatibilityBreakdown instance) =>
    <String, dynamic>{
      'personality_compatibility': instance.personalityCompatibility,
      'emotional_compatibility': instance.emotionalCompatibility,
      'lifestyle_compatibility': instance.lifestyleCompatibility,
      'communication_compatibility': instance.communicationCompatibility,
    };

MatchingUserProfile _$MatchingUserProfileFromJson(Map<String, dynamic> json) =>
    MatchingUserProfile(
      userId: json['user_id'] as String,
      profile: MatchingProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingUserProfileToJson(
        MatchingUserProfile instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'profile': instance.profile.toJson(),
    };

MatchingProfile _$MatchingProfileFromJson(Map<String, dynamic> json) =>
    MatchingProfile(
      basicInfo: BasicInfo.fromJson(json['basic_info'] as Map<String, dynamic>),
      personalityProfile: PersonalityProfile.fromJson(
          json['personality_profile'] as Map<String, dynamic>),
      lifestyleProfile: LifestyleProfile.fromJson(
          json['lifestyle_profile'] as Map<String, dynamic>),
      matchingPreferences: MatchingPreferences.fromJson(
          json['matching_preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingProfileToJson(MatchingProfile instance) =>
    <String, dynamic>{
      'basic_info': instance.basicInfo.toJson(),
      'personality_profile': instance.personalityProfile.toJson(),
      'lifestyle_profile': instance.lifestyleProfile.toJson(),
      'matching_preferences': instance.matchingPreferences.toJson(),
    };

BasicInfo _$BasicInfoFromJson(Map<String, dynamic> json) => BasicInfo(
      age: json['age'] as int,
      location: json['location'] as String,
      occupation: json['occupation'] as String,
    );

Map<String, dynamic> _$BasicInfoToJson(BasicInfo instance) =>
    <String, dynamic>{
      'age': instance.age,
      'location': instance.location,
      'occupation': instance.occupation,
    };

PersonalityProfile _$PersonalityProfileFromJson(Map<String, dynamic> json) =>
    PersonalityProfile(
      mbti: json['mbti'] as String,
      big5Summary: json['big5_summary'] as String,
      keyTraits: (json['key_traits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PersonalityProfileToJson(PersonalityProfile instance) =>
    <String, dynamic>{
      'mbti': instance.mbti,
      'big5_summary': instance.big5Summary,
      'key_traits': instance.keyTraits,
    };

LifestyleProfile _$LifestyleProfileFromJson(Map<String, dynamic> json) =>
    LifestyleProfile(
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      activityPreferences: (json['activity_preferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      communicationStyle: json['communication_style'] as String,
    );

Map<String, dynamic> _$LifestyleProfileToJson(LifestyleProfile instance) =>
    <String, dynamic>{
      'interests': instance.interests,
      'values': instance.values,
      'activity_preferences': instance.activityPreferences,
      'communication_style': instance.communicationStyle,
    };

MatchingPreferences _$MatchingPreferencesFromJson(Map<String, dynamic> json) =>
    MatchingPreferences(
      preferredAgeRange: (json['preferred_age_range'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      preferredMbti: (json['preferred_mbti'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      importantValues: (json['important_values'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MatchingPreferencesToJson(
        MatchingPreferences instance) =>
    <String, dynamic>{
      'preferred_age_range': instance.preferredAgeRange,
      'preferred_mbti': instance.preferredMbti,
      'important_values': instance.importantValues,
    };

UpdatePreferencesRequest _$UpdatePreferencesRequestFromJson(
        Map<String, dynamic> json) =>
    UpdatePreferencesRequest(
      ageRange: (json['age_range'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      locationPreference: (json['location_preference'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mbtiPreferences: (json['mbti_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      valuePriorities: (json['value_priorities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lifestylePreferences: json['lifestyle_preferences'] == null
          ? null
          : LifestylePreferences.fromJson(
              json['lifestyle_preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdatePreferencesRequestToJson(
        UpdatePreferencesRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('age_range', instance.ageRange);
  writeNotNull('location_preference', instance.locationPreference);
  writeNotNull('mbti_preferences', instance.mbtiPreferences);
  writeNotNull('value_priorities', instance.valuePriorities);
  writeNotNull('lifestyle_preferences', instance.lifestylePreferences?.toJson());
  return val;
}

LifestylePreferences _$LifestylePreferencesFromJson(
        Map<String, dynamic> json) =>
    LifestylePreferences(
      activityTypes: (json['activity_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialFrequency: json['social_frequency'] as String?,
      communicationStyle: json['communication_style'] as String?,
    );

Map<String, dynamic> _$LifestylePreferencesToJson(
        LifestylePreferences instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('activity_types', instance.activityTypes);
  writeNotNull('social_frequency', instance.socialFrequency);
  writeNotNull('communication_style', instance.communicationStyle);
  return val;
}

MatchingFeedbackRequest _$MatchingFeedbackRequestFromJson(
        Map<String, dynamic> json) =>
    MatchingFeedbackRequest(
      matchId: json['match_id'] as String,
      feedbackType: json['feedback_type'] as String,
      rating: json['rating'] as int,
      comments: json['comments'] as String?,
      interactionQuality: json['interaction_quality'] == null
          ? null
          : InteractionQuality.fromJson(
              json['interaction_quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchingFeedbackRequestToJson(
        MatchingFeedbackRequest instance) {
  final val = <String, dynamic>{
    'match_id': instance.matchId,
    'feedback_type': instance.feedbackType,
    'rating': instance.rating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('comments', instance.comments);
  writeNotNull('interaction_quality', instance.interactionQuality?.toJson());
  return val;
}

InteractionQuality _$InteractionQualityFromJson(Map<String, dynamic> json) =>
    InteractionQuality(
      communication: json['communication'] as int,
      compatibility: json['compatibility'] as int,
      interestLevel: json['interest_level'] as int,
    );

Map<String, dynamic> _$InteractionQualityToJson(InteractionQuality instance) =>
    <String, dynamic>{
      'communication': instance.communication,
      'compatibility': instance.compatibility,
      'interest_level': instance.interestLevel,
    };

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      message: json['message'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) {
  final val = <String, dynamic>{
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  return val;
}

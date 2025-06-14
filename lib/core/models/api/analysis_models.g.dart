// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryAnalysisRequest _$DiaryAnalysisRequestFromJson(
        Map<String, dynamic> json) =>
    DiaryAnalysisRequest(
      diaryId: json['diary_id'] as String,
      content: json['content'] as String,
      metadata: json['metadata'] == null
          ? null
          : DiaryMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DiaryAnalysisRequestToJson(
        DiaryAnalysisRequest instance) {
  final val = <String, dynamic>{
    'diary_id': instance.diaryId,
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata?.toJson());
  return val;
}

DiaryMetadata _$DiaryMetadataFromJson(Map<String, dynamic> json) =>
    DiaryMetadata(
      date: json['date'] as String?,
      weather: json['weather'] as String?,
      moodBefore: json['mood_before'] as String?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
    );

Map<String, dynamic> _$DiaryMetadataToJson(DiaryMetadata instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', instance.date);
  writeNotNull('weather', instance.weather);
  writeNotNull('mood_before', instance.moodBefore);
  writeNotNull('activities', instance.activities);
  writeNotNull('location', instance.location);
  return val;
}

DiaryAnalysisResponse _$DiaryAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    DiaryAnalysisResponse(
      diaryId: json['diary_id'] as String,
      analysisId: json['analysis_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      emotionAnalysis: EmotionAnalysis.fromJson(
          json['emotion_analysis'] as Map<String, dynamic>),
      personalityAnalysis: PersonalityAnalysis.fromJson(
          json['personality_analysis'] as Map<String, dynamic>),
      keywordExtraction: KeywordExtraction.fromJson(
          json['keyword_extraction'] as Map<String, dynamic>),
      lifestylePatterns: LifestylePatterns.fromJson(
          json['lifestyle_patterns'] as Map<String, dynamic>),
      insights:
          (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      analysisVersion: json['analysis_version'] as String,
      processingTime: (json['processing_time'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      processedAt: json['processed_at'] as String,
    );

Map<String, dynamic> _$DiaryAnalysisResponseToJson(
        DiaryAnalysisResponse instance) =>
    <String, dynamic>{
      'diary_id': instance.diaryId,
      'analysis_id': instance.analysisId,
      'user_id': instance.userId,
      'status': instance.status,
      'emotion_analysis': instance.emotionAnalysis.toJson(),
      'personality_analysis': instance.personalityAnalysis.toJson(),
      'keyword_extraction': instance.keywordExtraction.toJson(),
      'lifestyle_patterns': instance.lifestylePatterns.toJson(),
      'insights': instance.insights,
      'recommendations': instance.recommendations,
      'analysis_version': instance.analysisVersion,
      'processing_time': instance.processingTime,
      'confidence_score': instance.confidenceScore,
      'processed_at': instance.processedAt,
    };

EmotionAnalysis _$EmotionAnalysisFromJson(Map<String, dynamic> json) =>
    EmotionAnalysis(
      primaryEmotion: json['primary_emotion'] as String,
      secondaryEmotions: (json['secondary_emotions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sentimentScore: (json['sentiment_score'] as num).toDouble(),
      emotionalIntensity: (json['emotional_intensity'] as num).toDouble(),
      emotionalStability: (json['emotional_stability'] as num).toDouble(),
      emotionTimeline: EmotionTimeline.fromJson(
          json['emotion_timeline'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmotionAnalysisToJson(EmotionAnalysis instance) =>
    <String, dynamic>{
      'primary_emotion': instance.primaryEmotion,
      'secondary_emotions': instance.secondaryEmotions,
      'sentiment_score': instance.sentimentScore,
      'emotional_intensity': instance.emotionalIntensity,
      'emotional_stability': instance.emotionalStability,
      'emotion_timeline': instance.emotionTimeline.toJson(),
    };

EmotionTimeline _$EmotionTimelineFromJson(Map<String, dynamic> json) =>
    EmotionTimeline(
      beginning: json['beginning'] as String,
      middle: json['middle'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$EmotionTimelineToJson(EmotionTimeline instance) =>
    <String, dynamic>{
      'beginning': instance.beginning,
      'middle': instance.middle,
      'end': instance.end,
    };

PersonalityAnalysis _$PersonalityAnalysisFromJson(Map<String, dynamic> json) =>
    PersonalityAnalysis(
      mbtiIndicators: MbtiIndicators.fromJson(
          json['mbti_indicators'] as Map<String, dynamic>),
      big5Traits:
          Big5Traits.fromJson(json['big5_traits'] as Map<String, dynamic>),
      predictedMbti: json['predicted_mbti'] as String,
      confidenceLevel: (json['confidence_level'] as num).toDouble(),
      personalityInsights: (json['personality_insights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PersonalityAnalysisToJson(
        PersonalityAnalysis instance) =>
    <String, dynamic>{
      'mbti_indicators': instance.mbtiIndicators.toJson(),
      'big5_traits': instance.big5Traits.toJson(),
      'predicted_mbti': instance.predictedMbti,
      'confidence_level': instance.confidenceLevel,
      'personality_insights': instance.personalityInsights,
    };

MbtiIndicators _$MbtiIndicatorsFromJson(Map<String, dynamic> json) =>
    MbtiIndicators(
      extraversion: (json['extraversion'] as num).toDouble(),
      sensing: (json['sensing'] as num).toDouble(),
      thinking: (json['thinking'] as num).toDouble(),
      judging: (json['judging'] as num).toDouble(),
    );

Map<String, dynamic> _$MbtiIndicatorsToJson(MbtiIndicators instance) =>
    <String, dynamic>{
      'extraversion': instance.extraversion,
      'sensing': instance.sensing,
      'thinking': instance.thinking,
      'judging': instance.judging,
    };

Big5Traits _$Big5TraitsFromJson(Map<String, dynamic> json) => Big5Traits(
      openness: (json['openness'] as num).toDouble(),
      conscientiousness: (json['conscientiousness'] as num).toDouble(),
      extraversion: (json['extraversion'] as num).toDouble(),
      agreeableness: (json['agreeableness'] as num).toDouble(),
      neuroticism: (json['neuroticism'] as num).toDouble(),
    );

Map<String, dynamic> _$Big5TraitsToJson(Big5Traits instance) =>
    <String, dynamic>{
      'openness': instance.openness,
      'conscientiousness': instance.conscientiousness,
      'extraversion': instance.extraversion,
      'agreeableness': instance.agreeableness,
      'neuroticism': instance.neuroticism,
    };

KeywordExtraction _$KeywordExtractionFromJson(Map<String, dynamic> json) =>
    KeywordExtraction(
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
      entities:
          (json['entities'] as List<dynamic>).map((e) => e as String).toList(),
      themes:
          (json['themes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$KeywordExtractionToJson(KeywordExtraction instance) =>
    <String, dynamic>{
      'keywords': instance.keywords,
      'topics': instance.topics,
      'entities': instance.entities,
      'themes': instance.themes,
    };

LifestylePatterns _$LifestylePatternsFromJson(Map<String, dynamic> json) =>
    LifestylePatterns(
      activityPatterns: Map<String, double>.from(
          json['activity_patterns'] as Map),
      socialPatterns: Map<String, double>.from(
          json['social_patterns'] as Map),
      timePatterns: Map<String, double>.from(
          json['time_patterns'] as Map),
      interestAreas: (json['interest_areas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      valuesOrientation: Map<String, double>.from(
          json['values_orientation'] as Map),
    );

Map<String, dynamic> _$LifestylePatternsToJson(LifestylePatterns instance) =>
    <String, dynamic>{
      'activity_patterns': instance.activityPatterns,
      'social_patterns': instance.socialPatterns,
      'time_patterns': instance.timePatterns,
      'interest_areas': instance.interestAreas,
      'values_orientation': instance.valuesOrientation,
    };

UserEmotionPatterns _$UserEmotionPatternsFromJson(Map<String, dynamic> json) =>
    UserEmotionPatterns(
      userId: json['user_id'] as String,
      emotionPatterns: EmotionPatterns.fromJson(
          json['emotion_patterns'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserEmotionPatternsToJson(
        UserEmotionPatterns instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'emotion_patterns': instance.emotionPatterns.toJson(),
    };

EmotionPatterns _$EmotionPatternsFromJson(Map<String, dynamic> json) =>
    EmotionPatterns(
      dominantEmotions: (json['dominant_emotions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      emotionFrequency: Map<String, double>.from(
          json['emotion_frequency'] as Map),
      emotionalStability: (json['emotional_stability'] as num).toDouble(),
      moodTrends:
          MoodTrends.fromJson(json['mood_trends'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmotionPatternsToJson(EmotionPatterns instance) =>
    <String, dynamic>{
      'dominant_emotions': instance.dominantEmotions,
      'emotion_frequency': instance.emotionFrequency,
      'emotional_stability': instance.emotionalStability,
      'mood_trends': instance.moodTrends.toJson(),
    };

MoodTrends _$MoodTrendsFromJson(Map<String, dynamic> json) => MoodTrends(
      weeklyAverage: (json['weekly_average'] as num).toDouble(),
      monthlyTrend: json['monthly_trend'] as String,
      seasonalPattern: json['seasonal_pattern'] as String,
    );

Map<String, dynamic> _$MoodTrendsToJson(MoodTrends instance) =>
    <String, dynamic>{
      'weekly_average': instance.weeklyAverage,
      'monthly_trend': instance.monthlyTrend,
      'seasonal_pattern': instance.seasonalPattern,
    };

AnalysisHistoryResponse _$AnalysisHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    AnalysisHistoryResponse(
      userId: json['user_id'] as String,
      history: (json['history'] as List<dynamic>)
          .map((e) => AnalysisHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['total_count'] as int,
      pagination: PaginationInfo.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalysisHistoryResponseToJson(
        AnalysisHistoryResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'history': instance.history.map((e) => e.toJson()).toList(),
      'total_count': instance.totalCount,
      'pagination': instance.pagination.toJson(),
    };

AnalysisHistoryItem _$AnalysisHistoryItemFromJson(Map<String, dynamic> json) =>
    AnalysisHistoryItem(
      analysisId: json['analysis_id'] as String,
      diaryId: json['diary_id'] as String,
      primaryEmotion: json['primary_emotion'] as String,
      sentimentScore: (json['sentiment_score'] as num).toDouble(),
      processedAt: json['processed_at'] as String,
    );

Map<String, dynamic> _$AnalysisHistoryItemToJson(
        AnalysisHistoryItem instance) =>
    <String, dynamic>{
      'analysis_id': instance.analysisId,
      'diary_id': instance.diaryId,
      'primary_emotion': instance.primaryEmotion,
      'sentiment_score': instance.sentimentScore,
      'processed_at': instance.processedAt,
    };

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) =>
    PaginationInfo(
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$PaginationInfoToJson(PaginationInfo instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'offset': instance.offset,
      'has_more': instance.hasMore,
    };

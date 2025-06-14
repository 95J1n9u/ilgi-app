import 'package:json_annotation/json_annotation.dart';

part 'analysis_models.g.dart';

/// 일기 분석 요청
@JsonSerializable()
class DiaryAnalysisRequest {
  @JsonKey(name: 'diary_id')
  final String diaryId;

  final String content;

  final DiaryMetadata? metadata;

  const DiaryAnalysisRequest({
    required this.diaryId,
    required this.content,
    this.metadata,
  });

  factory DiaryAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$DiaryAnalysisRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryAnalysisRequestToJson(this);
}

/// 일기 메타데이터
@JsonSerializable()
class DiaryMetadata {
  final String? date;
  final String? weather;

  @JsonKey(name: 'mood_before')
  final String? moodBefore;

  final List<String>? activities;
  final String? location;

  const DiaryMetadata({
    this.date,
    this.weather,
    this.moodBefore,
    this.activities,
    this.location,
  });

  factory DiaryMetadata.fromJson(Map<String, dynamic> json) =>
      _$DiaryMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryMetadataToJson(this);
}

/// 일기 분석 응답
@JsonSerializable()
class DiaryAnalysisResponse {
  @JsonKey(name: 'diary_id')
  final String diaryId;

  @JsonKey(name: 'analysis_id')
  final String analysisId;

  @JsonKey(name: 'user_id')
  final String userId;

  final String status;

  @JsonKey(name: 'emotion_analysis')
  final EmotionAnalysis emotionAnalysis;

  @JsonKey(name: 'personality_analysis')
  final PersonalityAnalysis personalityAnalysis;

  @JsonKey(name: 'keyword_extraction')
  final KeywordExtraction keywordExtraction;

  @JsonKey(name: 'lifestyle_patterns')
  final LifestylePatterns lifestylePatterns;

  final List<String> insights;
  final List<String> recommendations;

  @JsonKey(name: 'analysis_version')
  final String analysisVersion;

  @JsonKey(name: 'processing_time')
  final double processingTime;

  @JsonKey(name: 'confidence_score')
  final double confidenceScore;

  @JsonKey(name: 'processed_at')
  final String processedAt;

  const DiaryAnalysisResponse({
    required this.diaryId,
    required this.analysisId,
    required this.userId,
    required this.status,
    required this.emotionAnalysis,
    required this.personalityAnalysis,
    required this.keywordExtraction,
    required this.lifestylePatterns,
    required this.insights,
    required this.recommendations,
    required this.analysisVersion,
    required this.processingTime,
    required this.confidenceScore,
    required this.processedAt,
  });

  factory DiaryAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryAnalysisResponseToJson(this);
}

/// 감정 분석 결과
@JsonSerializable()
class EmotionAnalysis {
  @JsonKey(name: 'primary_emotion')
  final String primaryEmotion;

  @JsonKey(name: 'secondary_emotions')
  final List<String> secondaryEmotions;

  @JsonKey(name: 'sentiment_score')
  final double sentimentScore;

  @JsonKey(name: 'emotional_intensity')
  final double emotionalIntensity;

  @JsonKey(name: 'emotional_stability')
  final double emotionalStability;

  @JsonKey(name: 'emotion_timeline')
  final EmotionTimeline emotionTimeline;

  const EmotionAnalysis({
    required this.primaryEmotion,
    required this.secondaryEmotions,
    required this.sentimentScore,
    required this.emotionalIntensity,
    required this.emotionalStability,
    required this.emotionTimeline,
  });

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$EmotionAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionAnalysisToJson(this);
}

/// 감정 타임라인
@JsonSerializable()
class EmotionTimeline {
  final String beginning;
  final String middle;
  final String end;

  const EmotionTimeline({
    required this.beginning,
    required this.middle,
    required this.end,
  });

  factory EmotionTimeline.fromJson(Map<String, dynamic> json) =>
      _$EmotionTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionTimelineToJson(this);
}

/// 성격 분석 결과
@JsonSerializable()
class PersonalityAnalysis {
  @JsonKey(name: 'mbti_indicators')
  final MbtiIndicators mbtiIndicators;

  @JsonKey(name: 'big5_traits')
  final Big5Traits big5Traits;

  @JsonKey(name: 'predicted_mbti')
  final String predictedMbti;

  @JsonKey(name: 'confidence_level')
  final double confidenceLevel;

  @JsonKey(name: 'personality_insights')
  final List<String> personalityInsights;

  const PersonalityAnalysis({
    required this.mbtiIndicators,
    required this.big5Traits,
    required this.predictedMbti,
    required this.confidenceLevel,
    required this.personalityInsights,
  });

  factory PersonalityAnalysis.fromJson(Map<String, dynamic> json) =>
      _$PersonalityAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityAnalysisToJson(this);
}

/// MBTI 지표
@JsonSerializable()
class MbtiIndicators {
  final double extraversion;
  final double sensing;
  final double thinking;
  final double judging;

  const MbtiIndicators({
    required this.extraversion,
    required this.sensing,
    required this.thinking,
    required this.judging,
  });

  factory MbtiIndicators.fromJson(Map<String, dynamic> json) =>
      _$MbtiIndicatorsFromJson(json);

  Map<String, dynamic> toJson() => _$MbtiIndicatorsToJson(this);
}

/// Big5 성격 특성
@JsonSerializable()
class Big5Traits {
  final double openness;
  final double conscientiousness;
  final double extraversion;
  final double agreeableness;
  final double neuroticism;

  const Big5Traits({
    required this.openness,
    required this.conscientiousness,
    required this.extraversion,
    required this.agreeableness,
    required this.neuroticism,
  });

  factory Big5Traits.fromJson(Map<String, dynamic> json) =>
      _$Big5TraitsFromJson(json);

  Map<String, dynamic> toJson() => _$Big5TraitsToJson(this);
}

/// 키워드 추출 결과
@JsonSerializable()
class KeywordExtraction {
  final List<String> keywords;
  final List<String> topics;
  final List<String> entities;
  final List<String> themes;

  const KeywordExtraction({
    required this.keywords,
    required this.topics,
    required this.entities,
    required this.themes,
  });

  factory KeywordExtraction.fromJson(Map<String, dynamic> json) =>
      _$KeywordExtractionFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordExtractionToJson(this);
}

/// 라이프스타일 패턴
@JsonSerializable()
class LifestylePatterns {
  @JsonKey(name: 'activity_patterns')
  final Map<String, double> activityPatterns;

  @JsonKey(name: 'social_patterns')
  final Map<String, double> socialPatterns;

  @JsonKey(name: 'time_patterns')
  final Map<String, double> timePatterns;

  @JsonKey(name: 'interest_areas')
  final List<String> interestAreas;

  @JsonKey(name: 'values_orientation')
  final Map<String, double> valuesOrientation;

  const LifestylePatterns({
    required this.activityPatterns,
    required this.socialPatterns,
    required this.timePatterns,
    required this.interestAreas,
    required this.valuesOrientation,
  });

  factory LifestylePatterns.fromJson(Map<String, dynamic> json) =>
      _$LifestylePatternsFromJson(json);

  Map<String, dynamic> toJson() => _$LifestylePatternsToJson(this);
}

/// 사용자 감정 패턴
@JsonSerializable()
class UserEmotionPatterns {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'emotion_patterns')
  final EmotionPatterns emotionPatterns;

  const UserEmotionPatterns({
    required this.userId,
    required this.emotionPatterns,
  });

  factory UserEmotionPatterns.fromJson(Map<String, dynamic> json) =>
      _$UserEmotionPatternsFromJson(json);

  Map<String, dynamic> toJson() => _$UserEmotionPatternsToJson(this);
}

/// 감정 패턴
@JsonSerializable()
class EmotionPatterns {
  @JsonKey(name: 'dominant_emotions')
  final List<String> dominantEmotions;

  @JsonKey(name: 'emotion_frequency')
  final Map<String, double> emotionFrequency;

  @JsonKey(name: 'emotional_stability')
  final double emotionalStability;

  @JsonKey(name: 'mood_trends')
  final MoodTrends moodTrends;

  const EmotionPatterns({
    required this.dominantEmotions,
    required this.emotionFrequency,
    required this.emotionalStability,
    required this.moodTrends,
  });

  factory EmotionPatterns.fromJson(Map<String, dynamic> json) =>
      _$EmotionPatternsFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionPatternsToJson(this);
}

/// 기분 트렌드
@JsonSerializable()
class MoodTrends {
  @JsonKey(name: 'weekly_average')
  final double weeklyAverage;

  @JsonKey(name: 'monthly_trend')
  final String monthlyTrend;

  @JsonKey(name: 'seasonal_pattern')
  final String seasonalPattern;

  const MoodTrends({
    required this.weeklyAverage,
    required this.monthlyTrend,
    required this.seasonalPattern,
  });

  factory MoodTrends.fromJson(Map<String, dynamic> json) =>
      _$MoodTrendsFromJson(json);

  Map<String, dynamic> toJson() => _$MoodTrendsToJson(this);
}

/// 분석 이력 응답
@JsonSerializable()
class AnalysisHistoryResponse {
  @JsonKey(name: 'user_id')
  final String userId;

  final List<AnalysisHistoryItem> history;

  @JsonKey(name: 'total_count')
  final int totalCount;

  final PaginationInfo pagination;

  const AnalysisHistoryResponse({
    required this.userId,
    required this.history,
    required this.totalCount,
    required this.pagination,
  });

  factory AnalysisHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisHistoryResponseToJson(this);
}

/// 분석 이력 항목
@JsonSerializable()
class AnalysisHistoryItem {
  @JsonKey(name: 'analysis_id')
  final String analysisId;

  @JsonKey(name: 'diary_id')
  final String diaryId;

  @JsonKey(name: 'primary_emotion')
  final String primaryEmotion;

  @JsonKey(name: 'sentiment_score')
  final double sentimentScore;

  @JsonKey(name: 'processed_at')
  final String processedAt;

  const AnalysisHistoryItem({
    required this.analysisId,
    required this.diaryId,
    required this.primaryEmotion,
    required this.sentimentScore,
    required this.processedAt,
  });

  factory AnalysisHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$AnalysisHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisHistoryItemToJson(this);
}

/// 페이지네이션 정보
@JsonSerializable()
class PaginationInfo {
  final int limit;
  final int offset;

  @JsonKey(name: 'has_more')
  final bool hasMore;

  const PaginationInfo({
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);
}

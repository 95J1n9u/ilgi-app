import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diary_write_provider.dart';

class DiaryPreviewBottomSheet extends ConsumerWidget {
  const DiaryPreviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final writeState = ref.watch(diaryWriteNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 핸들
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '일기 미리보기',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // 미리보기 내용
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 날짜 헤더
                      _PreviewDateHeader(),

                      const SizedBox(height: 20),

                      // 일기 내용
                      if (writeState.content.trim().isNotEmpty) ...[
                        Text(
                          '내용',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            writeState.content,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 감정 미리보기
                      if (writeState.selectedEmotions.isNotEmpty) ...[
                        Text(
                          '오늘의 감정',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _EmotionPreview(emotions: writeState.selectedEmotions),
                        const SizedBox(height: 20),
                      ],

                      // 날씨 미리보기
                      if (writeState.selectedWeather != null) ...[
                        Text(
                          '오늘의 날씨',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _WeatherPreview(weather: writeState.selectedWeather!),
                        const SizedBox(height: 20),
                      ],

                      // 활동 미리보기
                      if (writeState.selectedActivities.isNotEmpty) ...[
                        Text(
                          '오늘의 활동',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ActivityPreview(activities: writeState.selectedActivities),
                        const SizedBox(height: 20),
                      ],

                      // AI 분석 정보
                      if (writeState.aiAnalysisConsent) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.psychology,
                                    color: colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI 분석 예정',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '저장 후 AI가 감정 패턴과 성격 특성을 분석합니다.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 미리보기 날짜 헤더
class _PreviewDateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${now.year}년 ${now.month}월 ${now.day}일',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getWeekdayString(now.weekday),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[weekday - 1];
  }
}

// 감정 미리보기
class _EmotionPreview extends StatelessWidget {
  final List<String> emotions;

  const _EmotionPreview({required this.emotions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: emotions.map((emotion) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getEmotionColor(emotion).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getEmotionColor(emotion).withOpacity(0.5),
              ),
            ),
            child: Text(
              emotion,
              style: theme.textTheme.labelMedium?.copyWith(
                color: _getEmotionColor(emotion),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case '행복':
      case '기쁨':
        return Colors.amber;
      case '사랑':
      case '애정':
        return Colors.pink;
      case '슬픔':
      case '우울':
        return Colors.blue;
      case '분노':
      case '화남':
        return Colors.red;
      case '불안':
      case '걱정':
        return Colors.orange;
      case '평온':
      case '차분':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// 날씨 미리보기
class _WeatherPreview extends StatelessWidget {
  final String weather;

  const _WeatherPreview({required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final weatherInfo = _getWeatherInfo(weather);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            weatherInfo['emoji'] ?? '☀️',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Text(
            weatherInfo['name'] ?? '맑음',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getWeatherInfo(String weather) {
    switch (weather) {
      case 'sunny':
        return {'emoji': '☀️', 'name': '맑음'};
      case 'partly_cloudy':
        return {'emoji': '⛅', 'name': '구름조금'};
      case 'cloudy':
        return {'emoji': '☁️', 'name': '흐림'};
      case 'rainy':
        return {'emoji': '🌧️', 'name': '비'};
      case 'thunderstorm':
        return {'emoji': '⛈️', 'name': '천둥번개'};
      case 'snowy':
        return {'emoji': '❄️', 'name': '눈'};
      case 'foggy':
        return {'emoji': '🌫️', 'name': '안개'};
      case 'windy':
        return {'emoji': '🌪️', 'name': '바람'};
      default:
        return {'emoji': '☀️', 'name': '맑음'};
    }
  }
}

// 활동 미리보기
class _ActivityPreview extends StatelessWidget {
  final List<String> activities;

  const _ActivityPreview({required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: activities.map((activity) {
          final activityInfo = _getActivityInfo(activity);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activityInfo['emoji']!,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  activityInfo['name']!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Map<String, String> _getActivityInfo(String activity) {
    switch (activity) {
      case 'work_study':
        return {'emoji': '💼', 'name': '일/공부'};
      case 'meal':
        return {'emoji': '🍽️', 'name': '식사'};
      case 'friends':
        return {'emoji': '👥', 'name': '친구만남'};
      case 'date':
        return {'emoji': '💑', 'name': '연인'};
      case 'family':
        return {'emoji': '👨‍👩‍👧‍👦', 'name': '가족시간'};
      case 'exercise':
        return {'emoji': '🏃‍♂️', 'name': '운동'};
      case 'gaming':
        return {'emoji': '🎮', 'name': '게임'};
      case 'reading':
        return {'emoji': '📚', 'name': '독서'};
      case 'entertainment':
        return {'emoji': '🎬', 'name': '영화/드라마'};
      case 'music':
        return {'emoji': '🎵', 'name': '음악감상'};
      case 'hobby':
        return {'emoji': '🎨', 'name': '취미활동'};
      case 'shopping':
        return {'emoji': '🛍️', 'name': '쇼핑'};
      case 'travel':
        return {'emoji': '✈️', 'name': '여행'};
      case 'rest_home':
        return {'emoji': '🏠', 'name': '집에서휴식'};
      case 'drive':
        return {'emoji': '🚗', 'name': '드라이브'};
      case 'cafe':
        return {'emoji': '☕', 'name': '카페'};
      default:
        return {'emoji': '📝', 'name': activity};
    }
  }
}

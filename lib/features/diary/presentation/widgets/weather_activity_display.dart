import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherActivityDisplay extends StatelessWidget {
  final String? weather;
  final List<String> activities;
  final DateTime createdTime;

  const WeatherActivityDisplay({
    super.key,
    this.weather,
    required this.activities,
    required this.createdTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 첫 번째 행: 날씨 + 시간
            Row(
              children: [
                // 날씨
                if (weather != null) ...[
                  _WeatherDisplay(weather: weather!),
                  const SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: 24,
                    color: colorScheme.outline.withOpacity(0.3),
                  ),
                  const SizedBox(width: 16),
                ],

                // 작성 시간
                Expanded(
                  child: _TimeDisplay(createdTime: createdTime),
                ),
              ],
            ),

            // 활동 표시 (있는 경우)
            if (activities.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 1,
                color: colorScheme.outline.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              _ActivityDisplay(activities: activities),
            ],
          ],
        ),
      ),
    );
  }
}

// 날씨 표시 위젯
class _WeatherDisplay extends StatelessWidget {
  final String weather;

  const _WeatherDisplay({required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weatherData = _getWeatherData(weather);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          weatherData['emoji'] ?? '☀️',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '날씨',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            Text(
              weatherData['name'] ?? weather,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getWeatherData(String weather) {
    final weatherMap = {
      'sunny': {'emoji': '☀️', 'name': '맑음'},
      'partly_cloudy': {'emoji': '⛅', 'name': '구름조금'},
      'cloudy': {'emoji': '☁️', 'name': '흐림'},
      'rainy': {'emoji': '🌧️', 'name': '비'},
      'thunderstorm': {'emoji': '⛈️', 'name': '천둥번개'},
      'snowy': {'emoji': '❄️', 'name': '눈'},
      'foggy': {'emoji': '🌫️', 'name': '안개'},
      'windy': {'emoji': '🌪️', 'name': '바람'},
    };

    return weatherMap[weather] ?? {'emoji': '☀️', 'name': weather};
  }
}

// 시간 표시 위젯
class _TimeDisplay extends StatelessWidget {
  final DateTime createdTime;

  const _TimeDisplay({required this.createdTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final difference = now.difference(createdTime);

    String timeText;
    if (difference.inDays > 0) {
      timeText = '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      timeText = '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      timeText = '${difference.inMinutes}분 전';
    } else {
      timeText = '방금 전';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '작성 시간',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        Text(
          DateFormat('HH:mm').format(createdTime),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          timeText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

// 활동 표시 위젯
class _ActivityDisplay extends StatelessWidget {
  final List<String> activities;

  const _ActivityDisplay({required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_activity,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '오늘의 활동',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: activities.map((activity) {
            final activityData = _getActivityData(activity);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activityData['emoji'] ?? '📝',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    activityData['name'] ?? activity,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Map<String, String> _getActivityData(String activity) {
    final activityMap = {
      'work_study': {'emoji': '💼', 'name': '일/공부'},
      'meal': {'emoji': '🍽️', 'name': '식사'},
      'friends': {'emoji': '👥', 'name': '친구만남'},
      'date': {'emoji': '💑', 'name': '연인'},
      'family': {'emoji': '👨‍👩‍👧‍👦', 'name': '가족시간'},
      'exercise': {'emoji': '🏃‍♂️', 'name': '운동'},
      'gaming': {'emoji': '🎮', 'name': '게임'},
      'reading': {'emoji': '📚', 'name': '독서'},
      'entertainment': {'emoji': '🎬', 'name': '영화/드라마'},
      'music': {'emoji': '🎵', 'name': '음악감상'},
      'hobby': {'emoji': '🎨', 'name': '취미활동'},
      'shopping': {'emoji': '🛍️', 'name': '쇼핑'},
      'travel': {'emoji': '✈️', 'name': '여행'},
      'rest_home': {'emoji': '🏠', 'name': '집에서휴식'},
      'drive': {'emoji': '🚗', 'name': '드라이브'},
      'cafe': {'emoji': '☕', 'name': '카페'},
    };

    return activityMap[activity] ?? {'emoji': '📝', 'name': activity};
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diary_write_provider.dart';

class WeatherSelector extends ConsumerWidget {
  const WeatherSelector({super.key});

  static const List<WeatherData> _weathers = [
    WeatherData('☀️', '맑음', 'sunny', Colors.orange),
    WeatherData('⛅', '구름조금', 'partly_cloudy', Colors.blue),
    WeatherData('☁️', '흐림', 'cloudy', Colors.grey),
    WeatherData('🌧️', '비', 'rainy', Colors.blue),
    WeatherData('⛈️', '천둥번개', 'thunderstorm', Colors.purple),
    WeatherData('❄️', '눈', 'snowy', Colors.lightBlue),
    WeatherData('🌫️', '안개', 'foggy', Colors.grey),
    WeatherData('🌪️', '바람', 'windy', Colors.teal),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final writeState = ref.watch(diaryWriteNotifierProvider);
    final selectedWeather = writeState.selectedWeather;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _weathers.map((weather) {
          final isSelected = selectedWeather == weather.value;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _WeatherChip(
              weather: weather,
              isSelected: isSelected,
              onTap: () {
                ref.read(diaryWriteNotifierProvider.notifier)
                    .setWeather(isSelected ? null : weather.value);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 날씨 데이터 클래스
class WeatherData {
  final String emoji;
  final String name;
  final String value;
  final Color color;

  const WeatherData(this.emoji, this.name, this.value, this.color);
}

// 날씨 칩 위젯
class _WeatherChip extends StatelessWidget {
  final WeatherData weather;
  final bool isSelected;
  final VoidCallback onTap;

  const _WeatherChip({
    required this.weather,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? weather.color.withOpacity(0.2)
                  : colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected 
                    ? weather.color 
                    : colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weather.emoji,
                  style: TextStyle(
                    fontSize: isSelected ? 20 : 18,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  weather.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected 
                        ? weather.color 
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

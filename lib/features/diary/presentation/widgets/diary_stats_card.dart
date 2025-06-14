import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diary_provider.dart';

class DiaryStatsCard extends ConsumerWidget {
  const DiaryStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stats = ref.watch(diaryStatsProvider);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '일기 통계',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 통계 항목들
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.book,
                    label: '총 일기',
                    value: '${stats['totalDiaries']}개',
                    color: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.calendar_today,
                    label: '이번 주',
                    value: '${stats['thisWeekDiaries']}개',
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.trending_up,
                    label: '감정 트렌드',
                    value: stats['emotionTrend'] ?? '분석중',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_fire_department,
                    label: '연속 기록',
                    value: '${stats['longestStreak']}일',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

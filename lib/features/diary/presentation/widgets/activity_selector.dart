import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diary_write_provider.dart';

class ActivitySelector extends ConsumerWidget {
  const ActivitySelector({super.key});

  static const List<ActivityData> _activities = [
    ActivityData('💼', '일/공부', 'work_study'),
    ActivityData('🍽️', '식사', 'meal'),
    ActivityData('👥', '친구만남', 'friends'),
    ActivityData('💑', '연인', 'date'),
    ActivityData('👨‍👩‍👧‍👦', '가족시간', 'family'),
    ActivityData('🏃‍♂️', '운동', 'exercise'),
    ActivityData('🎮', '게임', 'gaming'),
    ActivityData('📚', '독서', 'reading'),
    ActivityData('🎬', '영화/드라마', 'entertainment'),
    ActivityData('🎵', '음악감상', 'music'),
    ActivityData('🎨', '취미활동', 'hobby'),
    ActivityData('🛍️', '쇼핑', 'shopping'),
    ActivityData('✈️', '여행', 'travel'),
    ActivityData('🏠', '집에서휴식', 'rest_home'),
    ActivityData('🚗', '드라이브', 'drive'),
    ActivityData('☕', '카페', 'cafe'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final writeState = ref.watch(diaryWriteNotifierProvider);
    final selectedActivities = writeState.selectedActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 선택된 활동들 표시
        if (selectedActivities.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedActivities.map((activity) {
                final activityData = _activities.firstWhere(
                  (a) => a.value == activity,
                  orElse: () => ActivityData('📝', activity, activity),
                );
                
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activityData.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activityData.name,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          ref.read(diaryWriteNotifierProvider.notifier)
                              .removeActivity(activity);
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 활동 선택 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            final isSelected = selectedActivities.contains(activity.value);
            
            return _ActivityChip(
              activity: activity,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) {
                  ref.read(diaryWriteNotifierProvider.notifier)
                      .removeActivity(activity.value);
                } else {
                  ref.read(diaryWriteNotifierProvider.notifier)
                      .addActivity(activity.value);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

// 활동 데이터 클래스
class ActivityData {
  final String emoji;
  final String name;
  final String value;

  const ActivityData(this.emoji, this.name, this.value);
}

// 활동 칩 위젯
class _ActivityChip extends StatelessWidget {
  final ActivityData activity;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityChip({
    required this.activity,
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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? colorScheme.secondary.withOpacity(0.2)
                  : colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? colorScheme.secondary 
                    : colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activity.emoji,
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected 
                        ? colorScheme.secondary 
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

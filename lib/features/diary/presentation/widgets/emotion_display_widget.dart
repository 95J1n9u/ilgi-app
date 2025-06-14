import 'package:flutter/material.dart';

class EmotionDisplayWidget extends StatelessWidget {
  final List<String> emotions;

  const EmotionDisplayWidget({
    super.key,
    required this.emotions,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(
                  Icons.mood,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '오늘의 감정',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 감정 태그들
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emotions.map((emotion) {
                final emotionData = _getEmotionData(emotion);

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: emotionData['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: emotionData['color'].withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        emotionData['emoji'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        emotion,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: emotionData['color'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // 감정 통계 (개수 표시)
            if (emotions.length > 1) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.insights,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '총 ${emotions.length}가지 감정을 느꼈어요',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 감정별 이모지와 색상 매핑
  Map<String, dynamic> _getEmotionData(String emotion) {
    final emotionMap = {
      '행복': {'emoji': '😊', 'color': Colors.amber},
      '기쁨': {'emoji': '😄', 'color': Colors.yellow},
      '사랑': {'emoji': '😍', 'color': Colors.pink},
      '애정': {'emoji': '🥰', 'color': Colors.pink},
      '슬픔': {'emoji': '😢', 'color': Colors.blue},
      '우울': {'emoji': '😔', 'color': Colors.indigo},
      '분노': {'emoji': '😠', 'color': Colors.red},
      '화남': {'emoji': '😡', 'color': Colors.red},
      '불안': {'emoji': '😰', 'color': Colors.orange},
      '걱정': {'emoji': '😟', 'color': Colors.orange},
      '평온': {'emoji': '😌', 'color': Colors.green},
      '차분': {'emoji': '😊', 'color': Colors.teal},
      '피곤': {'emoji': '😴', 'color': Colors.purple},
      '스트레스': {'emoji': '😣', 'color': Colors.deepOrange},
      '즐거움': {'emoji': '😆', 'color': Colors.lime},
      '만족': {'emoji': '😊', 'color': Colors.teal},
      '고민': {'emoji': '🤔', 'color': Colors.grey},
    };

    return emotionMap[emotion] ?? {'emoji': '😊', 'color': Colors.grey};
  }
}
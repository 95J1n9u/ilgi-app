import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionTrendChart extends ConsumerWidget {
  const EmotionTrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 임시 데이터 (실제로는 Provider에서 가져와야 함)
    final emotionData = _generateSampleData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insights,
                      color: colorScheme.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '최근 7일 감정 변화',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    _showDetailedChart(context);
                  },
                  icon: const Icon(Icons.bar_chart, size: 16),
                  label: const Text('자세히'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 차트 영역
            SizedBox(
              height: 120,
              child: _EmotionChart(data: emotionData),
            ),

            const SizedBox(height: 16),

            // 범례
            _EmotionLegend(data: emotionData),

            const SizedBox(height: 12),

            // 인사이트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI 인사이트',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getEmotionInsight(emotionData),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailedChart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '상세 감정 분석',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('상세 차트 구현 예정'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<EmotionDataPoint> _generateSampleData() {
    return [
      EmotionDataPoint('월', {'긍정': 70, '부정': 20, '중립': 10}),
      EmotionDataPoint('화', {'긍정': 80, '부정': 15, '중립': 5}),
      EmotionDataPoint('수', {'긍정': 60, '부정': 30, '중립': 10}),
      EmotionDataPoint('목', {'긍정': 75, '부정': 20, '중립': 5}),
      EmotionDataPoint('금', {'긍정': 85, '부정': 10, '중립': 5}),
      EmotionDataPoint('토', {'긍정': 90, '부정': 5, '중립': 5}),
      EmotionDataPoint('일', {'긍정': 65, '부정': 25, '중립': 10}),
    ];
  }

  String _getEmotionInsight(List<EmotionDataPoint> data) {
    final lastDay = data.last;
    final positiveRatio = lastDay.emotions['긍정'] ?? 0;
    
    if (positiveRatio >= 80) {
      return '최근 긍정적인 감정이 많이 나타나고 있어요! 이런 좋은 기분을 계속 유지해보세요.';
    } else if (positiveRatio >= 60) {
      return '전반적으로 균형 잡힌 감정 상태를 보이고 있어요. 꾸준히 기록해보세요.';
    } else {
      return '최근 부정적인 감정이 조금 늘어났네요. 스트레스 관리에 신경써보시길 권해요.';
    }
  }
}

// 감정 데이터 포인트 클래스
class EmotionDataPoint {
  final String day;
  final Map<String, int> emotions;

  EmotionDataPoint(this.day, this.emotions);
}

// 감정 차트 위젯
class _EmotionChart extends StatelessWidget {
  final List<EmotionDataPoint> data;

  const _EmotionChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((point) {
        return _ChartBar(
          day: point.day,
          positive: point.emotions['긍정'] ?? 0,
          negative: point.emotions['부정'] ?? 0,
          neutral: point.emotions['중립'] ?? 0,
        );
      }).toList(),
    );
  }
}

// 차트 바 위젯
class _ChartBar extends StatelessWidget {
  final String day;
  final int positive;
  final int negative;
  final int neutral;

  const _ChartBar({
    required this.day,
    required this.positive,
    required this.negative,
    required this.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = positive + negative + neutral;
    final maxHeight = 80.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 차트 바
        Container(
          width: 24,
          height: maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: theme.colorScheme.surfaceVariant,
          ),
          child: total > 0
              ? Column(
                  children: [
                    // 긍정
                    if (positive > 0)
                      Expanded(
                        flex: positive,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                negative == 0 && neutral == 0 ? 4 : 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // 중립
                    if (neutral > 0)
                      Expanded(
                        flex: neutral,
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    // 부정
                    if (negative > 0)
                      Expanded(
                        flex: negative,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                positive == 0 && neutral == 0 ? 4 : 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : null,
        ),

        const SizedBox(height: 8),

        // 요일 라벨
        Text(
          day,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// 범례 위젯
class _EmotionLegend extends StatelessWidget {
  final List<EmotionDataPoint> data;

  const _EmotionLegend({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: Colors.green,
          label: '긍정',
          theme: theme,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: Colors.grey,
          label: '중립',
          theme: theme,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: Colors.red,
          label: '부정',
          theme: theme,
        ),
      ],
    );
  }
}

// 범례 아이템 위젯
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final ThemeData theme;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
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

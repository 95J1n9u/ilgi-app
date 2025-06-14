import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/diary_model.dart';
import '../pages/diary_detail_page.dart';

class DiaryCard extends StatelessWidget {
  final DiaryModel diary;

  const DiaryCard({
    super.key,
    required this.diary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DiaryDetailPage(diaryId: diary.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (날짜, 날씨, 옵션)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // 날짜
                      Text(
                        DateFormat('MM월 dd일 (E)', 'ko').format(diary.createdAt),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (diary.weather != null) ...[
                        const SizedBox(width: 8),
                        // 날씨 아이콘
                        _WeatherIcon(weather: diary.weather!),
                      ],
                    ],
                  ),
                  // 더보기 메뉴
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('수정'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18),
                            SizedBox(width: 8),
                            Text('삭제'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        // 수정 페이지로 이동
                      } else if (value == 'delete') {
                        // 삭제 확인 다이얼로그
                        _showDeleteDialog(context);
                      }
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 일기 내용 미리보기
              Text(
                diary.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // 감정 태그들
              if (diary.emotions.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: diary.emotions.take(3).map((emotion) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getEmotionColor(emotion).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getEmotionColor(emotion).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        emotion,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getEmotionColor(emotion),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

              if (diary.emotions.length > 3) ...[
                const SizedBox(height: 6),
                Text(
                  '+${diary.emotions.length - 3}개 더',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // 하단 정보 (AI 분석 상태, 시간)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // AI 분석 상태
                  Row(
                    children: [
                      Icon(
                        diary.analysisStatus == 'completed'
                            ? Icons.psychology
                            : diary.analysisStatus == 'processing'
                            ? Icons.hourglass_empty
                            : Icons.psychology_outlined,
                        size: 16,
                        color: diary.analysisStatus == 'completed'
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        diary.analysisStatus == 'completed'
                            ? 'AI 분석 완료'
                            : diary.analysisStatus == 'processing'
                            ? 'AI 분석 중'
                            : 'AI 분석 대기',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: diary.analysisStatus == 'completed'
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  // 작성 시간
                  Text(
                    DateFormat('HH:mm').format(diary.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일기 삭제'),
        content: const Text('이 일기를 삭제하시겠습니까?\n삭제된 일기는 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              // 삭제 처리
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('일기가 삭제되었습니다')),
              );
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    // 감정별 색상 매핑
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

// 날씨 아이콘 위젯
class _WeatherIcon extends StatelessWidget {
  final String weather;

  const _WeatherIcon({required this.weather});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (weather.toLowerCase()) {
      case 'sunny':
      case '맑음':
        icon = Icons.wb_sunny;
        color = Colors.orange;
        break;
      case 'cloudy':
      case '흐림':
        icon = Icons.cloud;
        color = Colors.grey;
        break;
      case 'rainy':
      case '비':
        icon = Icons.grain;
        color = Colors.blue;
        break;
      case 'snowy':
      case '눈':
        icon = Icons.ac_unit;
        color = Colors.lightBlue;
        break;
      default:
        icon = Icons.wb_sunny;
        color = Colors.orange;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }
}
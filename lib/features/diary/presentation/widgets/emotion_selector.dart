import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diary_write_provider.dart';

class EmotionSelector extends ConsumerWidget {
  const EmotionSelector({super.key});

  // 기본 감정 목록
  static const List<EmotionData> _emotions = [
    EmotionData('😊', '행복', Colors.amber),
    EmotionData('😍', '사랑', Colors.pink),
    EmotionData('😌', '평온', Colors.green),
    EmotionData('😴', '피곤', Colors.purple),
    EmotionData('😢', '슬픔', Colors.blue),
    EmotionData('😠', '화남', Colors.red),
    EmotionData('😰', '불안', Colors.orange),
    EmotionData('😕', '우울', Colors.indigo),
    EmotionData('😆', '즐거움', Colors.yellow),
    EmotionData('🤔', '고민', Colors.grey),
    EmotionData('😊', '만족', Colors.teal),
    EmotionData('😣', '스트레스', Colors.deepOrange),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final writeState = ref.watch(diaryWriteNotifierProvider);
    final selectedEmotions = writeState.selectedEmotions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 선택된 감정들 표시
        if (selectedEmotions.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedEmotions.map((emotion) {
                final emotionData = _emotions.firstWhere(
                  (e) => e.name == emotion,
                  orElse: () => EmotionData('😊', emotion, Colors.grey),
                );
                
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: emotionData.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: emotionData.color.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        emotionData.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        emotionData.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: emotionData.color.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          ref.read(diaryWriteNotifierProvider.notifier)
                              .removeEmotion(emotion);
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: emotionData.color.withOpacity(0.7),
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

        // 감정 선택 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _emotions.length,
          itemBuilder: (context, index) {
            final emotion = _emotions[index];
            final isSelected = selectedEmotions.contains(emotion.name);
            
            return _EmotionChip(
              emotion: emotion,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) {
                  ref.read(diaryWriteNotifierProvider.notifier)
                      .removeEmotion(emotion.name);
                } else {
                  ref.read(diaryWriteNotifierProvider.notifier)
                      .addEmotion(emotion.name);
                }
              },
            );
          },
        ),

        const SizedBox(height: 12),

        // 커스텀 감정 추가 버튼
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _showCustomEmotionDialog(context, ref),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('다른 감정 추가'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomEmotionDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('감정 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '예: 설렘, 후회, 감사 등',
            labelText: '감정 이름',
          ),
          maxLength: 10,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final emotion = controller.text.trim();
              if (emotion.isNotEmpty) {
                ref.read(diaryWriteNotifierProvider.notifier)
                    .addEmotion(emotion);
                Navigator.of(context).pop();
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}

// 감정 데이터 클래스
class EmotionData {
  final String emoji;
  final String name;
  final Color color;

  const EmotionData(this.emoji, this.name, this.color);
}

// 감정 칩 위젯
class _EmotionChip extends StatelessWidget {
  final EmotionData emotion;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmotionChip({
    required this.emotion,
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
                  ? emotion.color.withOpacity(0.2)
                  : colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? emotion.color 
                    : colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emotion.emoji,
                  style: TextStyle(
                    fontSize: isSelected ? 28 : 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emotion.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected 
                        ? emotion.color 
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

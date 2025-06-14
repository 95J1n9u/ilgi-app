import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../core/models/diary_model.dart';
import '../providers/diary_provider.dart';
import '../widgets/ai_analysis_card.dart';
import '../widgets/emotion_display_widget.dart';
import '../widgets/weather_activity_display.dart';
import 'diary_write_page.dart';

class DiaryDetailPage extends ConsumerStatefulWidget {
  final String diaryId;

  const DiaryDetailPage({
    super.key,
    required this.diaryId,
  });

  @override
  ConsumerState<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryDetailPage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final diaryAsync = ref.watch(diaryProvider(widget.diaryId));

    return Scaffold(
      body: diaryAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(title: const Text('오류')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  '일기를 불러올 수 없습니다',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('돌아가기'),
                ),
              ],
            ),
          ),
        ),
        data: (diary) {
          if (diary == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('일기를 찾을 수 없음')),
              body: const Center(
                child: Text('해당 일기를 찾을 수 없습니다.'),
              ),
            );
          }

          return LoadingOverlay(
            isLoading: _isDeleting,
            loadingText: '일기를 삭제하는 중...',
            child: CustomScrollView(
              slivers: [
                // 상단 앱바
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      DateFormat('MM월 dd일 (E)', 'ko').format(diary.createdAt),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.secondary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    // 편집 버튼
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editDiary(diary),
                    ),
                    // 더보기 메뉴
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, size: 18),
                              SizedBox(width: 8),
                              Text('공유하기'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'export',
                          child: Row(
                            children: [
                              Icon(Icons.download, size: 18),
                              SizedBox(width: 8),
                              Text('내보내기'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('삭제하기', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'share':
                            _shareDiary(diary);
                            break;
                          case 'export':
                            _exportDiary(diary);
                            break;
                          case 'delete':
                            _showDeleteDialog(diary);
                            break;
                        }
                      },
                    ),
                  ],
                ),

                // 일기 내용
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 메타데이터 (날씨, 활동)
                      WeatherActivityDisplay(
                        weather: diary.weather,
                        activities: diary.activities,
                        createdTime: diary.createdAt,
                      ),

                      const SizedBox(height: 20),

                      // 일기 내용
                      _DiaryContentCard(diary: diary),

                      const SizedBox(height: 20),

                      // 감정 표시
                      if (diary.emotions.isNotEmpty) ...[
                        EmotionDisplayWidget(emotions: diary.emotions),
                        const SizedBox(height: 20),
                      ],

                      // AI 분석 결과
                      AIAnalysisCard(diary: diary),

                      const SizedBox(height: 32),

                      // 관련 일기 추천 (임시)
                      _RelatedDiariesSection(),

                      const SizedBox(height: 100), // 하단 여백
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 일기 편집
  void _editDiary(DiaryModel diary) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryWritePage(editingDiary: diary),
      ),
    );
  }

  // 일기 공유
  void _shareDiary(DiaryModel diary) {
    // TODO: 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공유 기능은 곧 출시됩니다!')),
    );
  }

  // 일기 내보내기
  void _exportDiary(DiaryModel diary) {
    // TODO: PDF/텍스트 내보내기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('내보내기 기능은 곧 출시됩니다!')),
    );
  }

  // 삭제 확인 다이얼로그
  void _showDeleteDialog(DiaryModel diary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일기 삭제'),
        content: const Text(
          '이 일기를 삭제하시겠습니까?\n삭제된 일기는 복구할 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteDiary(diary);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  // 일기 삭제
  Future<void> _deleteDiary(DiaryModel diary) async {
    setState(() => _isDeleting = true);

    try {
      await ref.read(diaryRepositoryProvider).deleteDiary(diary.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일기가 삭제되었습니다')),
        );
        Navigator.of(context).pop(); // 페이지 닫기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }
}

// 일기 내용 카드
class _DiaryContentCard extends StatelessWidget {
  final DiaryModel diary;

  const _DiaryContentCard({required this.diary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '일기 내용',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${diary.content.length}자',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 일기 내용
            SelectableText(
              diary.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            // 작성 시간
            Text(
              '작성 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(diary.createdAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),

            if (diary.updatedAt != diary.createdAt) ...[
              const SizedBox(height: 4),
              Text(
                '수정 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(diary.updatedAt)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 관련 일기 섹션 (임시)
class _RelatedDiariesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비슷한 감정의 일기',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 32,
                  color: colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Text(
                  'AI 분석 완료 후\n관련 일기를 추천해드릴게요',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
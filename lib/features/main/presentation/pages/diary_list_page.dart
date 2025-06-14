import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../diary/presentation/pages/diary_write_page.dart';
import '../../../diary/presentation/providers/diary_provider.dart';
import '../../../diary/presentation/widgets/diary_card.dart';
import '../../../diary/presentation/widgets/diary_stats_card.dart';
import '../../../diary/presentation/widgets/emotion_trend_chart.dart';

class DiaryListPage extends ConsumerStatefulWidget {
  const DiaryListPage({super.key});

  @override
  ConsumerState<DiaryListPage> createState() => _DiaryListPageState();
}

class _DiaryListPageState extends ConsumerState<DiaryListPage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final diariesAsync = ref.watch(diariesProvider);

    return Scaffold(
      body: CustomScrollView(
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
                '나의 일기',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // 일기 검색 기능
                  _showSearchDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  // 달력 뷰로 전환
                  _showCalendarView(context);
                },
              ),
            ],
          ),

          // 통계 카드
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: DiaryStatsCard(),
            ),
          ),

          // 감정 트렌드 차트
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: EmotionTrendChart(),
            ),
          ),

          // 일기 목록 섹션 헤더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '최근 일기',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // 전체 일기 보기
                    },
                    icon: const Icon(Icons.list, size: 16),
                    label: const Text('전체보기'),
                  ),
                ],
              ),
            ),
          ),

          // 일기 목록
          diariesAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
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
                    ],
                  ),
                ),
              ),
            ),
            data: (diaries) {
              if (diaries.isEmpty) {
                return SliverToBoxAdapter(
                  child: _EmptyState(),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final diary = diaries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DiaryCard(diary: diary),
                      );
                    },
                    childCount: diaries.length,
                  ),
                ),
              );
            },
          ),

          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
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
                    '일기 검색',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 검색 기능 구현
                const Expanded(
                  child: Center(
                    child: Text('검색 기능 구현 예정'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCalendarView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('달력 뷰 구현 예정'),
          ),
        ),
      ),
    );
  }
}

// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.book_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '첫 번째 일기를 작성해보세요',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI가 당신의 감정을 분석하고\n완벽한 상대를 찾아드릴게요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DiaryWritePage(),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('일기 작성하기'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/diary_model.dart';

class AIAnalysisCard extends ConsumerWidget {
  final DiaryModel diary;

  const AIAnalysisCard({
    super.key,
    required this.diary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI 감정 분석',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getAnalysisStatusText(diary.analysisStatus),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getAnalysisStatusColor(diary.analysisStatus, colorScheme),
                        ),
                      ),
                    ],
                  ),
                ),
                _getAnalysisStatusIcon(diary.analysisStatus, colorScheme),
              ],
            ),

            const SizedBox(height: 16),

            // 분석 내용
            _buildAnalysisContent(context, diary),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisContent(BuildContext context, DiaryModel diary) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (diary.analysisStatus) {
      case 'completed':
        return _buildCompletedAnalysis(context, diary);
      case 'processing':
        return _buildProcessingState(context);
      case 'failed':
        return _buildFailedState(context);
      case 'skipped':
        return _buildSkippedState(context);
      default:
        return _buildPendingState(context);
    }
  }

  // 완료된 분석 결과
  Widget _buildCompletedAnalysis(BuildContext context, DiaryModel diary) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final analysisResult = diary.analysisResult ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 감정 점수
        if (analysisResult['emotionScores'] != null) ...[
          _AnalysisSection(
            title: '감정 분석',
            icon: Icons.mood,
            child: _buildEmotionScores(context, analysisResult['emotionScores']),
          ),
          const SizedBox(height: 16),
        ],

        // 성격 인사이트
        if (analysisResult['personalityInsights'] != null) ...[
          _AnalysisSection(
            title: '성격 인사이트',
            icon: Icons.person,
            child: _buildPersonalityInsights(context, analysisResult['personalityInsights']),
          ),
          const SizedBox(height: 16),
        ],

        // 키워드 추출
        if (analysisResult['keywords'] != null) ...[
          _AnalysisSection(
            title: '주요 키워드',
            icon: Icons.tag,
            child: _buildKeywords(context, analysisResult['keywords']),
          ),
          const SizedBox(height: 16),
        ],

        // AI 추천사항
        if (analysisResult['recommendations'] != null) ...[
          _AnalysisSection(
            title: 'AI 추천',
            icon: Icons.lightbulb,
            child: _buildRecommendations(context, analysisResult['recommendations']),
          ),
        ],

        // 더 자세한 분석 보기 버튼
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _showDetailedAnalysis(context, diary),
            icon: const Icon(Icons.analytics, size: 18),
            label: const Text('상세 분석 보기'),
          ),
        ),
      ],
    );
  }

  // 처리 중 상태
  Widget _buildProcessingState(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'AI가 일기 내용을 분석하고 있습니다...\n잠시만 기다려주세요.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 실패 상태
  Widget _buildFailedState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'AI 분석 중 오류가 발생했습니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _retryAnalysis(context),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('다시 분석'),
          ),
        ),
      ],
    );
  }

  // 건너뛴 상태
  Widget _buildSkippedState(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'AI 분석에 동의하지 않으셔서 분석이 진행되지 않았습니다.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _enableAnalysis(context),
            icon: const Icon(Icons.psychology, size: 18),
            label: const Text('지금 분석하기'),
          ),
        ),
      ],
    );
  }

  // 대기 상태
  Widget _buildPendingState(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule,
              color: Theme.of(context).colorScheme.outline,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'AI 분석이 대기 중입니다.\n분석이 완료되면 알려드릴게요.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 감정 점수 표시
  Widget _buildEmotionScores(BuildContext context, Map<String, dynamic> scores) {
    final theme = Theme.of(context);
    final emotions = scores.entries.take(3).toList();

    return Column(
      children: emotions.map((entry) {
        final emotion = entry.key;
        final score = (entry.value as num).toDouble();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  emotion,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${score.toInt()}%',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 성격 인사이트 표시
  Widget _buildPersonalityInsights(BuildContext context, List<dynamic> insights) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: insights.take(3).map((insight) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.toString(),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 키워드 표시
  Widget _buildKeywords(BuildContext context, List<dynamic> keywords) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: keywords.take(6).map((keyword) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            keyword.toString(),
            style: theme.textTheme.labelSmall,
          ),
        );
      }).toList(),
    );
  }

  // 추천사항 표시
  Widget _buildRecommendations(BuildContext context, List<dynamic> recommendations) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recommendations.take(2).map((rec) {
          return Text(
            '💡 ${rec.toString()}',
            style: theme.textTheme.bodySmall,
          );
        }).toList(),
      ),
    );
  }

  // 상태별 텍스트
  String _getAnalysisStatusText(String status) {
    switch (status) {
      case 'completed':
        return '분석 완료';
      case 'processing':
        return '분석 중...';
      case 'failed':
        return '분석 실패';
      case 'skipped':
        return '분석 안함';
      default:
        return '분석 대기';
    }
  }

  // 상태별 색상
  Color _getAnalysisStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'completed':
        return colorScheme.primary;
      case 'processing':
        return Colors.orange;
      case 'failed':
        return colorScheme.error;
      case 'skipped':
        return colorScheme.outline;
      default:
        return colorScheme.outline;
    }
  }

  // 상태별 아이콘
  Widget _getAnalysisStatusIcon(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'completed':
        return Icon(Icons.check_circle, color: colorScheme.primary, size: 20);
      case 'processing':
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      case 'failed':
        return Icon(Icons.error, color: colorScheme.error, size: 20);
      default:
        return Icon(Icons.schedule, color: colorScheme.outline, size: 20);
    }
  }

  // 상세 분석 보기
  void _showDetailedAnalysis(BuildContext context, DiaryModel diary) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('상세 AI 분석')),
          body: const Center(
            child: Text('상세 AI 분석 페이지 구현 예정'),
          ),
        ),
      ),
    );
  }

  // 분석 재시도
  void _retryAnalysis(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI 분석을 다시 요청했습니다')),
    );
  }

  // 분석 활성화
  void _enableAnalysis(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI 분석을 시작했습니다')),
    );
  }
}

// 분석 섹션 위젯
class _AnalysisSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _AnalysisSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
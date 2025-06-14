import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../core/models/diary_model.dart';
import '../providers/diary_write_provider.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/weather_selector.dart';
import '../widgets/activity_selector.dart';
import '../widgets/diary_preview_bottom_sheet.dart';

class DiaryWritePage extends ConsumerStatefulWidget {
  final DiaryModel? editingDiary;

  const DiaryWritePage({
    super.key,
    this.editingDiary,
  });

  @override
  ConsumerState<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends ConsumerState<DiaryWritePage> {
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _scrollController = ScrollController();
  
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    
    // 편집 모드인 경우 기존 데이터 로드
    if (widget.editingDiary != null) {
      _loadExistingDiary();
    }
    
    // 텍스트 변경 감지
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadExistingDiary() {
    final diary = widget.editingDiary!;
    _contentController.text = diary.content;
    
    // Provider에 기존 데이터 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(diaryWriteNotifierProvider.notifier);
      notifier.loadExistingDiary(diary);
    });
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
    
    // Provider에 텍스트 업데이트
    ref.read(diaryWriteNotifierProvider.notifier)
        .updateContent(_contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final writeState = ref.watch(diaryWriteNotifierProvider);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) {
        if (!didPop && _hasUnsavedChanges) {
          _showExitDialog();
        }
      },
      child: LoadingOverlay(
        isLoading: writeState.isLoading,
        loadingText: '일기를 저장하는 중...',
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editingDiary != null ? '일기 수정' : '일기 작성'),
            elevation: 0,
            backgroundColor: colorScheme.surface,
            actions: [
              // 미리보기 버튼
              TextButton(
                onPressed: writeState.content.trim().isEmpty 
                    ? null 
                    : _showPreview,
                child: const Text('미리보기'),
              ),
              // 저장 버튼
              TextButton(
                onPressed: writeState.canSave ? _saveDiary : null,
                child: Text(
                  widget.editingDiary != null ? '수정' : '저장',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: writeState.canSave 
                        ? colorScheme.primary 
                        : colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
          
          body: Column(
            children: [
              // 진행률 표시
              if (writeState.content.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _calculateProgress(writeState.content.length),
                    backgroundColor: colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(writeState.content.length, colorScheme),
                    ),
                  ),
                ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 오늘 날짜 표시
                      _DateHeader(),
                      
                      const SizedBox(height: 16),
                      
                      // 일기 내용 입력
                      _ContentInputSection(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 감정 선택
                      _SectionTitle(
                        title: '오늘의 감정',
                        subtitle: '지금 느끼는 감정을 선택해주세요 (복수 선택 가능)',
                      ),
                      const SizedBox(height: 12),
                      const EmotionSelector(),
                      
                      const SizedBox(height: 24),
                      
                      // 날씨 선택
                      _SectionTitle(
                        title: '오늘의 날씨',
                        subtitle: '오늘 하루 날씨는 어땠나요?',
                      ),
                      const SizedBox(height: 12),
                      const WeatherSelector(),
                      
                      const SizedBox(height: 24),
                      
                      // 활동 선택
                      _SectionTitle(
                        title: '오늘의 활동',
                        subtitle: '오늘 무엇을 하셨나요? (선택사항)',
                      ),
                      const SizedBox(height: 12),
                      const ActivitySelector(),
                      
                      const SizedBox(height: 32),
                      
                      // AI 분석 동의
                      _AIAnalysisConsent(),
                      
                      const SizedBox(height: 100), // 하단 여백
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // 하단 저장 버튼
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 글자 수 표시
                  if (writeState.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${writeState.content.length}자',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                          Text(
                            _getEncouragementText(writeState.content.length),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: _getProgressColor(writeState.content.length, colorScheme),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // 저장 버튼
                  CustomButton(
                    text: widget.editingDiary != null ? '일기 수정하기' : '일기 저장하기',
                    onPressed: writeState.canSave ? _saveDiary : null,
                    size: ButtonSize.large,
                    width: double.infinity,
                    isLoading: writeState.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 진행률 계산 (0~1)
  double _calculateProgress(int length) {
    if (length < 50) return length / 50 * 0.3; // 0~30%
    if (length < 200) return 0.3 + (length - 50) / 150 * 0.4; // 30~70%
    if (length < 500) return 0.7 + (length - 200) / 300 * 0.3; // 70~100%
    return 1.0;
  }

  // 진행률에 따른 색상
  Color _getProgressColor(int length, ColorScheme colorScheme) {
    if (length < 50) return Colors.red;
    if (length < 200) return Colors.orange;
    if (length < 500) return colorScheme.primary;
    return Colors.green;
  }

  // 격려 메시지
  String _getEncouragementText(int length) {
    if (length < 50) return '조금만 더 써보세요!';
    if (length < 200) return '좋아요! 계속 써보세요';
    if (length < 500) return '훌륭해요! 거의 다 됐어요';
    return '완벽한 일기네요!';
  }

  // 미리보기 표시
  void _showPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DiaryPreviewBottomSheet(),
    );
  }

  // 일기 저장
  Future<void> _saveDiary() async {
    try {
      final notifier = ref.read(diaryWriteNotifierProvider.notifier);
      await notifier.saveDiary();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.editingDiary != null 
                  ? '일기가 수정되었습니다' 
                  : '일기가 저장되었습니다',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        
        Navigator.of(context).pop(true); // 저장 성공 표시
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // 나가기 다이얼로그
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('작성 중단'),
        content: const Text('작성 중인 내용이 있습니다.\n저장하지 않고 나가시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('계속 작성'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).pop(); // 페이지 나가기
            },
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }
}

// 날짜 헤더 위젯
class _DateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${now.year}년 ${now.month}월 ${now.day}일',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getWeekdayString(now.weekday),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[weekday - 1];
  }
}

// 일기 내용 입력 섹션
class _ContentInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _ContentInputSection({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 하루는 어떠셨나요?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '자유롭게 오늘의 이야기를 들려주세요. AI가 당신의 감정을 분석해드릴게요.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: null,
            minLines: 8,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: '예: 오늘은 친구들과 맛있는 저녁을 먹었어요. 오랜만에 만나서 정말 즐거웠고...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.outline,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}

// 섹션 제목 위젯
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// AI 분석 동의 위젯
class _AIAnalysisConsent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final writeState = ref.watch(diaryWriteNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AI 분석 동의',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'AI가 일기 내용을 분석하여 감정 패턴과 성격 특성을 파악하고, 매칭에 활용합니다. 분석된 데이터는 안전하게 보호됩니다.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: writeState.aiAnalysisConsent,
                onChanged: (value) {
                  ref.read(diaryWriteNotifierProvider.notifier)
                      .setAIAnalysisConsent(value ?? false);
                },
                activeColor: colorScheme.primary,
              ),
              Expanded(
                child: Text(
                  'AI 분석에 동의합니다 (매칭 기능 이용을 위해 필요)',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/api/analysis_models.dart';
import '../features/diary/presentation/providers/diary_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../shared/widgets/loading/loading_overlay.dart';

/// API 연동 예제 - 일기 작성 및 AI 분석
class DiaryWriteExamplePage extends ConsumerStatefulWidget {
  const DiaryWriteExamplePage({super.key});

  @override
  ConsumerState<DiaryWriteExamplePage> createState() => _DiaryWriteExamplePageState();
}

class _DiaryWriteExamplePageState extends ConsumerState<DiaryWriteExamplePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedWeather;
  String? _selectedMood;
  List<String> _selectedActivities = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final diaryState = ref.watch(diaryNotifierProvider);
    final diaryNotifier = ref.read(diaryNotifierProvider.notifier);

    // 인증되지 않은 경우
    if (!authState.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('일기 작성')),
        body: const Center(
          child: Text('로그인이 필요합니다'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 분석 일기 작성'),
        actions: [
          // API 연결 상태 표시
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  authState.isApiConnected 
                    ? Icons.cloud_done 
                    : Icons.cloud_off,
                  color: authState.isApiConnected 
                    ? Colors.green 
                    : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  authState.isApiConnected ? 'API 연결됨' : 'API 연결 안됨',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: diaryState.isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 에러 메시지
              if (diaryState.error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          diaryState.error!,
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => diaryNotifier.clearError(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

              // 제목 입력
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 내용 입력
              TextField(
                controller: _contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: '일기 내용',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // 날씨 선택
              DropdownButtonFormField<String>(
                value: _selectedWeather,
                decoration: const InputDecoration(
                  labelText: '날씨',
                  border: OutlineInputBorder(),
                ),
                items: ['맑음', '흐림', '비', '눈', '바람']
                    .map((weather) => DropdownMenuItem(
                          value: weather,
                          child: Text(weather),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedWeather = value),
              ),
              const SizedBox(height: 16),

              // 기분 선택
              DropdownButtonFormField<String>(
                value: _selectedMood,
                decoration: const InputDecoration(
                  labelText: '기분',
                  border: OutlineInputBorder(),
                ),
                items: ['매우 좋음', '좋음', '보통', '나쁨', '매우 나쁨']
                    .map((mood) => DropdownMenuItem(
                          value: mood,
                          child: Text(mood),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedMood = value),
              ),
              const SizedBox(height: 16),

              // 활동 선택 (다중 선택)
              Wrap(
                spacing: 8,
                children: ['운동', '독서', '영화감상', '친구만남', '요리', '쇼핑', '게임']
                    .map((activity) => FilterChip(
                          label: Text(activity),
                          selected: _selectedActivities.contains(activity),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedActivities.add(activity);
                              } else {
                                _selectedActivities.remove(activity);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // AI 분석 상태 표시
              if (diaryState.isAnalyzing)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('AI가 일기를 분석하고 있습니다...'),
                    ],
                  ),
                ),

              // 최근 분석 결과 표시
              if (diaryState.lastAnalysis != null)
                _buildAnalysisResult(diaryState.lastAnalysis!),

              const SizedBox(height: 24),

              // 저장 버튼
              ElevatedButton(
                onPressed: _canSave() ? _saveDiary : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  diaryState.isLoading ? '저장 중...' : '일기 저장 및 AI 분석',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSave() {
    return _titleController.text.trim().isNotEmpty &&
           _contentController.text.trim().isNotEmpty &&
           !ref.read(diaryNotifierProvider).isLoading;
  }

  Future<void> _saveDiary() async {
    final diaryNotifier = ref.read(diaryNotifierProvider.notifier);
    
    final diaryId = await diaryNotifier.createDiaryWithAnalysis(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      weather: _selectedWeather,
      mood: _selectedMood,
      activities: _selectedActivities,
      location: '서울', // 실제로는 위치 서비스에서 가져와야 함
    );

    if (diaryId != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일기가 성공적으로 저장되었습니다. AI 분석이 진행 중입니다.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Widget _buildAnalysisResult(DiaryAnalysisResponse analysis) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.green.shade600),
              const SizedBox(width: 8),
              Text(
                'AI 분석 결과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 주요 감정
          _buildAnalysisItem(
            '주요 감정',
            analysis.emotionAnalysis.primaryEmotion,
            Icons.sentiment_satisfied,
          ),
          
          // 감정 점수
          _buildAnalysisItem(
            '감정 점수',
            '${(analysis.emotionAnalysis.sentimentScore * 100).toInt()}%',
            Icons.trending_up,
          ),
          
          // 예상 MBTI
          _buildAnalysisItem(
            '예상 성격 유형',
            analysis.personalityAnalysis.predictedMbti,
            Icons.person,
          ),
          
          // 키워드
          if (analysis.keywordExtraction.keywords.isNotEmpty)
            _buildAnalysisItem(
              '핵심 키워드',
              analysis.keywordExtraction.keywords.take(3).join(', '),
              Icons.tag,
            ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}

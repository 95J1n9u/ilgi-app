import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/api/matching_models.dart';
import '../features/matching/presentation/providers/matching_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../shared/widgets/loading/loading_overlay.dart';

/// API 연동 예제 - 매칭 기능
class MatchingExamplePage extends ConsumerStatefulWidget {
  const MatchingExamplePage({super.key});

  @override
  ConsumerState<MatchingExamplePage> createState() => _MatchingExamplePageState();
}

class _MatchingExamplePageState extends ConsumerState<MatchingExamplePage> {
  int _currentIndex = 0;
  List<int> _ageRange = [25, 35];
  List<String> _selectedMbtiTypes = [];
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 매칭 후보 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatchingCandidates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final matchingState = ref.watch(matchingNotifierProvider);

    // 인증되지 않은 경우
    if (!authState.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('매칭')),
        body: const Center(
          child: Text('로그인이 필요합니다'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 매칭'),
        actions: [
          // 필터 버튼
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: Icon(
              Icons.tune,
              color: matchingState.currentFilters != null 
                ? Theme.of(context).primaryColor 
                : null,
            ),
          ),
          // 새로고침 버튼
          IconButton(
            onPressed: _loadMatchingCandidates,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: matchingState.isLoading,
        child: Column(
          children: [
            // 에러 메시지
            if (matchingState.error != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
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
                        matchingState.error!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(matchingNotifierProvider.notifier).clearError(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

            // 현재 적용된 필터 표시
            if (matchingState.currentFilters != null)
              _buildActiveFilters(matchingState.currentFilters!),

            // 매칭 후보 목록
            Expanded(
              child: matchingState.candidates.isEmpty
                ? _buildEmptyState()
                : PageView.builder(
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: matchingState.candidates.length,
                    itemBuilder: (context, index) {
                      final candidate = matchingState.candidates[index];
                      return _buildCandidateCard(candidate, index);
                    },
                  ),
            ),

            // 하단 액션 버튼들
            if (matchingState.candidates.isNotEmpty)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(MatchingFilters filters) {
    final List<String> activeFilters = [];
    
    if (filters.ageRange != null) {
      activeFilters.add('연령: ${filters.ageRange![0]}-${filters.ageRange![1]}세');
    }
    if (filters.location != null) {
      activeFilters.add('지역: ${filters.location}');
    }
    if (filters.mbtiTypes != null && filters.mbtiTypes!.isNotEmpty) {
      activeFilters.add('MBTI: ${filters.mbtiTypes!.join(', ')}');
    }

    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt, size: 16, color: Colors.blue.shade600),
              const SizedBox(width: 4),
              Text(
                '적용된 필터',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: activeFilters
                .map((filter) => Chip(
                      label: Text(filter),
                      backgroundColor: Colors.blue.shade100,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '매칭 후보가 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '필터를 조정하거나 잠시 후 다시 시도해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadMatchingCandidates,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 찾기'),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(MatchingCandidate candidate, int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 호환성 점수 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${index + 1}/${ref.read(matchingNotifierProvider).candidates.length}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCompatibilityColor(candidate.compatibilityScore),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '호환성 ${(candidate.compatibilityScore * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 프로필 정보
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${candidate.profilePreview.age}세',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          candidate.profilePreview.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 성격 요약
              Text(
                '성격',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                candidate.profilePreview.personalitySummary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              // 관심사
              Text(
                '관심사',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: candidate.profilePreview.interests
                    .map((interest) => Chip(
                          label: Text(interest),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // 공통점
              if (candidate.sharedTraits.isNotEmpty) ...[
                Text(
                  '공통점',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: candidate.sharedTraits
                      .map((trait) => Chip(
                            label: Text(trait),
                            backgroundColor: Colors.green.shade50,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              // 매칭 점수 상세
              _buildCompatibilityDetails(candidate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompatibilityDetails(MatchingCandidate candidate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '세부 호환성',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCompatibilityItem(
          '성격 매칭',
          candidate.personalityMatch.mbtiCompatibility,
          Icons.psychology,
        ),
        _buildCompatibilityItem(
          '라이프스타일',
          candidate.lifestyleMatch.activityOverlap,
          Icons.favorite,
        ),
        _buildCompatibilityItem(
          '가치관',
          candidate.lifestyleMatch.valueAlignment,
          Icons.star,
        ),
      ],
    );
  }

  Widget _buildCompatibilityItem(String label, double score, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            '${(score * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _getCompatibilityColor(score),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final candidate = ref.read(matchingNotifierProvider).candidates[_currentIndex];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 패스 버튼
          FloatingActionButton(
            onPressed: () => _onCandidateAction(candidate, false),
            backgroundColor: Colors.red.shade100,
            heroTag: 'pass',
            child: Icon(
              Icons.close,
              color: Colors.red.shade600,
              size: 32,
            ),
          ),
          
          // 상세 정보 버튼
          FloatingActionButton(
            onPressed: () => _showCandidateDetails(candidate),
            backgroundColor: Colors.blue.shade100,
            heroTag: 'info',
            child: Icon(
              Icons.info,
              color: Colors.blue.shade600,
              size: 28,
            ),
          ),
          
          // 좋아요 버튼
          FloatingActionButton(
            onPressed: () => _onCandidateAction(candidate, true),
            backgroundColor: Colors.green.shade100,
            heroTag: 'like',
            child: Icon(
              Icons.favorite,
              color: Colors.green.shade600,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  void _loadMatchingCandidates() {
    final matchingNotifier = ref.read(matchingNotifierProvider.notifier);
    
    // 필터 생성
    MatchingFilters? filters;
    if (_ageRange.isNotEmpty || _selectedMbtiTypes.isNotEmpty || _selectedLocation != null) {
      final matchingService = ref.read(matchingServiceProvider);
      filters = matchingService.createFilters(
        ageRange: _ageRange,
        location: _selectedLocation,
        mbtiTypes: _selectedMbtiTypes.isNotEmpty ? _selectedMbtiTypes : null,
      );
    }

    matchingNotifier.loadMatchingCandidates(
      limit: 10,
      minCompatibility: 0.6,
      filters: filters,
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('매칭 필터'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 연령대 선택
              Text('연령대: ${_ageRange[0]}세 - ${_ageRange[1]}세'),
              RangeSlider(
                values: RangeValues(_ageRange[0].toDouble(), _ageRange[1].toDouble()),
                min: 18,
                max: 60,
                divisions: 42,
                labels: RangeLabels('${_ageRange[0]}', '${_ageRange[1]}'),
                onChanged: (values) {
                  setState(() {
                    _ageRange = [values.start.round(), values.end.round()];
                  });
                },
              ),
              const SizedBox(height: 16),

              // 지역 선택
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: '지역',
                  border: OutlineInputBorder(),
                ),
                items: ['서울', '부산', '대구', '인천', '광주', '대전', '울산']
                    .map((location) => DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedLocation = value),
              ),
              const SizedBox(height: 16),

              // MBTI 선택
              const Text('선호 MBTI'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: ['ENFP', 'ENFJ', 'ENTP', 'ENTJ', 'ESFP', 'ESFJ', 'ESTP', 'ESTJ',
                          'INFP', 'INFJ', 'INTP', 'INTJ', 'ISFP', 'ISFJ', 'ISTP', 'ISTJ']
                    .map((mbti) => FilterChip(
                          label: Text(mbti),
                          selected: _selectedMbtiTypes.contains(mbti),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMbtiTypes.add(mbti);
                              } else {
                                _selectedMbtiTypes.remove(mbti);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _ageRange = [25, 35];
                _selectedLocation = null;
                _selectedMbtiTypes.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('초기화'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadMatchingCandidates();
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _onCandidateAction(MatchingCandidate candidate, bool isLike) {
    // 후보 제거
    ref.read(matchingNotifierProvider.notifier).removeCandidate(candidate.candidateId);
    
    // 다음 후보로 이동
    if (_currentIndex >= ref.read(matchingNotifierProvider).candidates.length) {
      setState(() => _currentIndex = 0);
    }

    // 피드백 제출 (실제로는 서버에 전송)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLike ? '좋아요를 보냈습니다!' : '다음 후보를 확인하세요'),
        backgroundColor: isLike ? Colors.green : Colors.orange,
      ),
    );

    // 남은 후보가 적으면 추가 로드
    if (ref.read(matchingNotifierProvider).candidates.length < 3) {
      _loadMatchingCandidates();
    }
  }

  void _showCandidateDetails(MatchingCandidate candidate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상세 호환성 분석'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('전체 호환성: ${(candidate.compatibilityScore * 100).toInt()}%'),
              const SizedBox(height: 16),
              Text('MBTI 호환성: ${(candidate.personalityMatch.mbtiCompatibility * 100).toInt()}%'),
              Text('성격 유사도: ${(candidate.personalityMatch.big5Similarity * 100).toInt()}%'),
              Text('소통 스타일: ${candidate.personalityMatch.communicationStyle}'),
              const SizedBox(height: 12),
              Text('활동 유사도: ${(candidate.lifestyleMatch.activityOverlap * 100).toInt()}%'),
              Text('가치관 일치도: ${(candidate.lifestyleMatch.valueAlignment * 100).toInt()}%'),
              Text('사회적 패턴: ${(candidate.lifestyleMatch.socialPatternFit * 100).toInt()}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Color _getCompatibilityColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.7) return Colors.lightGreen;
    if (score >= 0.6) return Colors.orange;
    if (score >= 0.5) return Colors.deepOrange;
    return Colors.red;
  }
}

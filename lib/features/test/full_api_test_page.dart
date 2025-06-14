import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/api/analysis_models.dart';
import '../../../core/models/api/matching_models.dart';
import '../../../core/services/analysis_service.dart';
import '../../../core/services/matching_service.dart';

class FullApiTestPage extends ConsumerStatefulWidget {
  const FullApiTestPage({super.key});

  @override
  ConsumerState<FullApiTestPage> createState() => _FullApiTestPageState();
}

class _FullApiTestPageState extends ConsumerState<FullApiTestPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;
  String _testResult = '';
  String _selectedTest = 'connection';
  
  // 일기 분석 테스트용
  final _diaryContentController = TextEditingController(
    text: '오늘은 친구들과 카페에서 즐거운 시간을 보냈다. 새로운 프로젝트에 대해 이야기하면서 많은 아이디어를 얻었고, 앞으로의 계획에 대해 설레는 마음이 든다.',
  );
  
  // 매칭 테스트용
  int _ageMin = 25;
  int _ageMax = 35;
  String? _selectedLocation = '서울';

  @override
  void initState() {
    super.initState();
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  @override
  void dispose() {
    _diaryContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 API 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 서버 정보
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API 서버 정보',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Base URL: ${ApiConstants.baseUrl}'),
                    Text('환경: ${ApiConstants.isDevelopment ? "개발" : "운영"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 테스트 종류 선택
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '테스트 종류 선택',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedTest,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'connection', child: Text('1. 기본 연결 테스트')),
                        DropdownMenuItem(value: 'health', child: Text('2. Health Check')),
                        DropdownMenuItem(value: 'flutter', child: Text('3. Flutter 연결 테스트')),
                        DropdownMenuItem(value: 'status', child: Text('4. API 상태 확인')),
                        DropdownMenuItem(value: 'diary_analysis', child: Text('5. 일기 분석 API')),
                        DropdownMenuItem(value: 'matching', child: Text('6. 매칭 API')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedTest = value!;
                          _testResult = '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 일기 분석 테스트용 입력
                    if (_selectedTest == 'diary_analysis') ...[
                      Text(
                        '일기 내용 (테스트용)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _diaryContentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '분석할 일기 내용을 입력하세요...',
                        ),
                      ),
                    ],
                    
                    // 매칭 테스트용 입력
                    if (_selectedTest == 'matching') ...[
                      Text(
                        '매칭 필터 설정',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('연령: $_ageMin세 - $_ageMax세'),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(_ageMin.toDouble(), _ageMax.toDouble()),
                        min: 18,
                        max: 60,
                        divisions: 42,
                        labels: RangeLabels('$_ageMin', '$_ageMax'),
                        onChanged: (values) {
                          setState(() {
                            _ageMin = values.start.round();
                            _ageMax = values.end.round();
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: const InputDecoration(
                          labelText: '지역',
                          border: OutlineInputBorder(),
                        ),
                        items: ['서울', '부산', '대구', '인천', '광주', '대전']
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedLocation = value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 테스트 실행 버튼
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runSelectedTest,
              icon: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
              label: Text(_isLoading ? '테스트 중...' : '테스트 실행'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 결과 표시
            if (_testResult.isNotEmpty) ...[
              Expanded(
                child: Card(
                  color: _testResult.contains('✅') 
                      ? Colors.green.shade50 
                      : _testResult.contains('❌')
                        ? Colors.red.shade50
                        : Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '테스트 결과',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => setState(() => _testResult = ''),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _testResult,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Future<void> _runSelectedTest() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
    });

    try {
      String result = '';
      
      switch (_selectedTest) {
        case 'connection':
          result = await _testBasicConnection();
          break;
        case 'health':
          result = await _testHealthCheck();
          break;
        case 'flutter':
          result = await _testFlutterConnection();
          break;
        case 'status':
          result = await _testApiStatus();
          break;
        case 'diary_analysis':
          result = await _testDiaryAnalysis();
          break;
        case 'matching':
          result = await _testMatching();
          break;
      }
      
      setState(() {
        _testResult = result;
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 테스트 실패!\n오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<String> _testBasicConnection() async {
    final response = await _dio.get('/');
    if (response.statusCode == 200) {
      return '✅ 기본 연결 성공!\n상태 코드: ${response.statusCode}\n\n응답 데이터:\n${_formatJson(response.data)}';
    } else {
      return '❌ 연결 실패\n상태 코드: ${response.statusCode}';
    }
  }
  
  Future<String> _testHealthCheck() async {
    final response = await _dio.get('/health');
    if (response.statusCode == 200) {
      return '✅ Health Check 성공!\n상태 코드: ${response.statusCode}\n\n응답 데이터:\n${_formatJson(response.data)}';
    } else {
      return '❌ Health Check 실패\n상태 코드: ${response.statusCode}';
    }
  }
  
  Future<String> _testFlutterConnection() async {
    final response = await _dio.get('/api/v1/flutter/test');
    if (response.statusCode == 200) {
      return '✅ Flutter 연결 테스트 성공!\n상태 코드: ${response.statusCode}\n\n응답 데이터:\n${_formatJson(response.data)}';
    } else {
      return '❌ Flutter 연결 테스트 실패\n상태 코드: ${response.statusCode}';
    }
  }
  
  Future<String> _testApiStatus() async {
    final response = await _dio.get('/api/v1/status');
    if (response.statusCode == 200) {
      return '✅ API 상태 확인 성공!\n상태 코드: ${response.statusCode}\n\n응답 데이터:\n${_formatJson(response.data)}';
    } else {
      return '❌ API 상태 확인 실패\n상태 코드: ${response.statusCode}';
    }
  }
  
  Future<String> _testDiaryAnalysis() async {
    try {
      // 더미 요청 데이터 생성
      final requestData = {
        'diary_id': 'test_diary_${DateTime.now().millisecondsSinceEpoch}',
        'content': _diaryContentController.text.trim(),
        'metadata': {
          'date': DateTime.now().toIso8601String().split('T')[0],
          'weather': '맑음',
          'mood_before': '보통',
          'activities': ['친구만남', '카페'],
          'location': '서울',
        },
      };
      
      print('일기 분석 요청 데이터: ${_formatJson(requestData)}');
      
      final response = await _dio.post(
        '/api/v1/analysis/diary',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final analysisResult = response.data;
        return '✅ 일기 분석 API 성공!\n상태 코드: ${response.statusCode}\n\n'
               '분석 결과 요약:\n'
               '- 분석 ID: ${analysisResult['analysis_id']}\n'
               '- 주요 감정: ${analysisResult['emotion_analysis']['primary_emotion']}\n'
               '- 감정 점수: ${(analysisResult['emotion_analysis']['sentiment_score'] * 100).toInt()}%\n'
               '- 예상 MBTI: ${analysisResult['personality_analysis']['predicted_mbti']}\n'
               '- 신뢰도: ${(analysisResult['confidence_score'] * 100).toInt()}%\n'
               '- 처리 시간: ${analysisResult['processing_time']}초\n\n'
               '전체 응답 데이터:\n${_formatJson(analysisResult)}';
      } else {
        return '❌ 일기 분석 API 실패\n상태 코드: ${response.statusCode}\n응답: ${response.data}';
      }
    } catch (e) {
      if (e is DioException) {
        return '❌ 일기 분석 API 오류\n'
               'HTTP 상태: ${e.response?.statusCode}\n'
               '오류 메시지: ${e.message}\n'
               '응답 데이터: ${e.response?.data}';
      }
      return '❌ 일기 분석 API 예외\n오류: $e';
    }
  }
  
  Future<String> _testMatching() async {
    try {
      // 더미 매칭 요청 데이터 생성
      final requestData = {
        'limit': 5,
        'min_compatibility': 0.6,
        'filters': {
          'age_range': [_ageMin, _ageMax],
          'location': _selectedLocation,
          'interests': ['독서', '영화감상'],
          'mbti_types': ['ENFJ', 'INFP'],
        },
      };
      
      print('매칭 요청 데이터: ${_formatJson(requestData)}');
      
      final response = await _dio.post(
        '/api/v1/matching/candidates',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final matchingResult = response.data;
        final candidates = matchingResult['candidates'] as List;
        
        String candidatesSummary = '';
        for (int i = 0; i < candidates.length; i++) {
          final candidate = candidates[i];
          candidatesSummary += '${i + 1}. 호환성: ${(candidate['compatibility_score'] * 100).toInt()}%, '
                              '나이: ${candidate['profile_preview']['age']}세, '
                              '지역: ${candidate['profile_preview']['location']}\n';
        }
        
        return '✅ 매칭 API 성공!\n상태 코드: ${response.statusCode}\n\n'
               '매칭 결과 요약:\n'
               '- 총 후보 수: ${matchingResult['total_count']}\n'
               '- 반환된 후보 수: ${candidates.length}\n\n'
               '후보 목록:\n$candidatesSummary\n'
               '전체 응답 데이터:\n${_formatJson(matchingResult)}';
      } else {
        return '❌ 매칭 API 실패\n상태 코드: ${response.statusCode}\n응답: ${response.data}';
      }
    } catch (e) {
      if (e is DioException) {
        return '❌ 매칭 API 오류\n'
               'HTTP 상태: ${e.response?.statusCode}\n'
               '오류 메시지: ${e.message}\n'
               '응답 데이터: ${e.response?.data}';
      }
      return '❌ 매칭 API 예외\n오류: $e';
    }
  }
  
  String _formatJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../../core/constants/api_constants.dart';

class ApiConnectionTestPage extends ConsumerStatefulWidget {
  const ApiConnectionTestPage({super.key});

  @override
  ConsumerState<ApiConnectionTestPage> createState() => _ApiConnectionTestPageState();
}

class _ApiConnectionTestPageState extends ConsumerState<ApiConnectionTestPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;
  String _testResult = '';
  Map<String, dynamic>? _responseData;

  @override
  void initState() {
    super.initState();
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _responseData = null;
    });

    try {
      print('API 연결 테스트 시작...');
      print('요청 URL: ${ApiConstants.baseUrl}');
      
      final response = await _dio.get('/');
      
      setState(() {
        _testResult = '✅ 연결 성공!\n상태 코드: ${response.statusCode}';
        _responseData = response.data;
      });
      
      print('연결 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');
    } catch (e) {
      print('연결 실패: $e');
      setState(() {
        _testResult = '❌ 연결 실패!\n오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testHealthCheck() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _responseData = null;
    });

    try {
      print('Health Check 테스트 시작...');
      print('요청 URL: ${ApiConstants.baseUrl}/health');
      
      final response = await _dio.get('/health');
      
      setState(() {
        _testResult = '✅ Health Check 성공!\n상태 코드: ${response.statusCode}';
        _responseData = response.data;
      });
      
      print('Health Check 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');
    } catch (e) {
      print('Health Check 실패: $e');
      setState(() {
        _testResult = '❌ Health Check 실패!\n오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testFlutterConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _responseData = null;
    });

    try {
      print('Flutter 연결 테스트 시작...');
      print('요청 URL: ${ApiConstants.baseUrl}/api/v1/flutter/test');
      
      final response = await _dio.get('/api/v1/flutter/test');
      
      setState(() {
        _testResult = '✅ Flutter 연결 테스트 성공!\n상태 코드: ${response.statusCode}';
        _responseData = response.data;
      });
      
      print('Flutter 연결 테스트 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');
    } catch (e) {
      print('Flutter 연결 테스트 실패: $e');
      setState(() {
        _testResult = '❌ Flutter 연결 테스트 실패!\n오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testApiStatus() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _responseData = null;
    });

    try {
      print('API 상태 테스트 시작...');
      print('요청 URL: ${ApiConstants.baseUrl}/api/v1/status');
      
      final response = await _dio.get('/api/v1/status');
      
      setState(() {
        _testResult = '✅ API 상태 확인 성공!\n상태 코드: ${response.statusCode}';
        _responseData = response.data;
      });
      
      print('API 상태 확인 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');
    } catch (e) {
      print('API 상태 확인 실패: $e');
      setState(() {
        _testResult = '❌ API 상태 확인 실패!\n오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 연결 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    Text('연결 타임아웃: ${ApiConstants.connectTimeout.inSeconds}초'),
                    Text('수신 타임아웃: ${ApiConstants.receiveTimeout.inSeconds}초'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 테스트 버튼들
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: const Icon(Icons.wifi),
              label: const Text('기본 연결 테스트'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testHealthCheck,
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Health Check'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testFlutterConnection,
              icon: const Icon(Icons.flutter_dash),
              label: const Text('Flutter 연결 테스트'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testApiStatus,
              icon: const Icon(Icons.api),
              label: const Text('API 상태 확인'),
            ),
            
            const SizedBox(height: 24),
            
            if (_isLoading) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('테스트 중...'),
                  ],
                ),
              ),
            ],
            
            if (_testResult.isNotEmpty) ...[
              Card(
                color: _testResult.contains('✅') 
                    ? Colors.green.shade50 
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '테스트 결과',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            if (_responseData != null) ...[
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '응답 데이터',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _formatJson(_responseData!),
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
  
  String _formatJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}

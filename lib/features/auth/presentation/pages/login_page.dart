import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../core/utils/validators.dart';
import '../../../../app/routes/app_routes.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // AuthWrapper가 자동으로 처리하므로 수동 라우팅 제거
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인 성공!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleTestLogin() async {
    setState(() => _isLoading = true);

    try {
      // AuthNotifier의 익명 로그인 사용
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signInAnonymously();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('테스트 로그인 성공!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('테스트 로그인 실패: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그아웃 완료! 이제 깨끗한 상태입니다.'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃 실패: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Google 로그인 핸들러 (임시 비활성화)
  // Future<void> _handleGoogleLogin() async {
  //   setState(() => _isLoading = true);

  //   try {
  //     final authNotifier = ref.read(authNotifierProvider.notifier);
  //     await authNotifier.signInWithGoogle();

  //     // AuthWrapper가 자동으로 처리하므로 수동 라우팅 제거
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Google 로그인 성공!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Google 로그인 실패: ${e.toString()}'),
  //           backgroundColor: Theme.of(context).colorScheme.error,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingText: '로그인 중...',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // 앱 로고 및 제목
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'AI Diary Matching',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '당신의 감정을 이해하는 AI가\n완벽한 상대를 찾아드려요',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // 로그인 폼
                  CustomTextField(
                    label: '이메일',
                    hint: 'example@email.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: Validators.email,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: '비밀번호',
                    hint: '8자 이상 입력해주세요',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: Validators.password,
                  ),

                  const SizedBox(height: 8),

                  // 비밀번호 찾기
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // 임시로 비활성화
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('비밀번호 찾기 기능은 곧 추가될 예정입니다.'),
                          ),
                        );
                      },
                      child: const Text('비밀번호를 잊으셨나요?'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 로그인 버튼
                  CustomButton(
                    text: '로그인',
                    onPressed: _handleLogin,
                    size: ButtonSize.large,
                    width: double.infinity,
                  ),

                  const SizedBox(height: 16),

                  // 또는 구분선
                  Row(
                    children: [
                      Expanded(child: Divider(color: colorScheme.outline)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '또는',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: colorScheme.outline)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Google 로그인 버튼 (임시 비활성화)
                  // CustomButton(
                  //   text: 'Google로 로그인',
                  //   onPressed: _handleGoogleLogin,
                  //   type: ButtonType.outline,
                  //   size: ButtonSize.large,
                  //   width: double.infinity,
                  //   icon: Icons.g_mobiledata,
                  // ),

                  const SizedBox(height: 16),

                  // 테스트 로그인 버튼 (임시)
                  CustomButton(
                    text: '테스트 로그인 (익명)',
                    onPressed: _handleTestLogin,
                    type: ButtonType.secondary,
                    size: ButtonSize.large,
                    width: double.infinity,
                    icon: Icons.science,
                  ),

                  const SizedBox(height: 8),

                  // 로그아웃 버튼 (테스트용)
                  CustomButton(
                    text: '로그아웃 (초기화)',
                    onPressed: _handleLogout,
                    type: ButtonType.text,
                    size: ButtonSize.small,
                    width: double.infinity,
                    icon: Icons.logout,
                  ),

                  const Spacer(),

                  // 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직 계정이 없으시나요? ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          // 회원가입 페이지로 이동
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

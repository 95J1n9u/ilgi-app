import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../core/utils/validators.dart';
import '../../../../app/routes/app_routes.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year - 18); // 최소 18세

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('ko'),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedBirthDate = selectedDate;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('성별을 선택해주세요')),
      );
      return;
    }

    if (!_agreeToTerms || !_agreeToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약관에 동의해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        birthDate: _selectedBirthDate!,
        gender: _selectedGender!,
      );

      if (mounted) {
        // 이메일 인증 안내 페이지로 이동
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.emailVerification,
          arguments: _emailController.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입 실패: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingText: '계정을 생성하는 중...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 안내 텍스트
                Text(
                  'AI가 당신의 감정을 분석하여\n완벽한 상대를 찾아드려요',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // 이름
                CustomTextField(
                  label: '이름',
                  hint: '실명을 입력해주세요',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: Validators.name,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 16),

                // 이메일
                CustomTextField(
                  label: '이메일',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: Validators.email,
                ),

                const SizedBox(height: 16),

                // 비밀번호
                CustomTextField(
                  label: '비밀번호',
                  hint: '8자 이상, 영문+숫자 조합',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: Validators.password,
                ),

                const SizedBox(height: 16),

                // 비밀번호 확인
                CustomTextField(
                  label: '비밀번호 확인',
                  hint: '비밀번호를 다시 입력해주세요',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // 생년월일
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '생년월일',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectBirthDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: colorScheme.outline,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedBirthDate != null
                                  ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일'
                                  : '생년월일을 선택해주세요',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: _selectedBirthDate != null
                                    ? colorScheme.onSurface
                                    : colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 성별
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '성별',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _GenderOption(
                            title: '남성',
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _GenderOption(
                            title: '여성',
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 약관 동의
                _AgreementCheckbox(
                  title: '서비스 이용약관에 동의합니다',
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  onDetailPressed: () {
                    // 약관 상세 페이지 이동
                  },
                ),

                _AgreementCheckbox(
                  title: '개인정보 처리방침에 동의합니다',
                  value: _agreeToPrivacy,
                  onChanged: (value) {
                    setState(() {
                      _agreeToPrivacy = value ?? false;
                    });
                  },
                  onDetailPressed: () {
                    // 개인정보 처리방침 상세 페이지 이동
                  },
                ),

                const SizedBox(height: 32),

                // 회원가입 버튼
                CustomButton(
                  text: '회원가입',
                  onPressed: _handleRegister,
                  size: ButtonSize.large,
                  width: double.infinity,
                ),

                const SizedBox(height: 16),

                // 로그인 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이미 계정이 있으시나요? ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 성별 선택 위젯
class _GenderOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _GenderOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 약관 동의 체크박스
class _AgreementCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onDetailPressed;

  const _AgreementCheckbox({
    required this.title,
    required this.value,
    required this.onChanged,
    this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (onDetailPressed != null)
            TextButton(
              onPressed: onDetailPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
              child: const Text('보기'),
            ),
        ],
      ),
    );
  }
}
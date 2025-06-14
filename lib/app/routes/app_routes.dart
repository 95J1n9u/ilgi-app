import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/diary/presentation/pages/diary_list_page.dart';
import '../../features/diary/presentation/pages/diary_write_page.dart';
import '../../features/diary/presentation/pages/diary_detail_page.dart';
import '../../features/matching/presentation/pages/matching_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/test/api_connection_test_page.dart';
import '../../features/test/full_api_test_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profileSetup = '/profile-setup';
  static const String emailVerification = '/email-verification';
  static const String resetPassword = '/reset-password';
  static const String main = '/main';

  // 일기 관련
  static const String diaryList = '/diary/list';
  static const String diaryWrite = '/diary/write';
  static const String diaryDetail = '/diary/detail';

  // 매칭 관련
  static const String matching = '/matching';

  // 채팅 관련
  static const String chatList = '/chat/list';
  static const String chatDetail = '/chat/detail';

  // 프로필 관련
  static const String profile = '/profile';

  // 개발/테스트 관련
  static const String apiTest = '/test/api';
  static const String fullApiTest = '/test/full-api';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
      return MaterialPageRoute(builder: (_) => const _SplashScreen());
      
      case login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
      
      case register:
      return MaterialPageRoute(builder: (_) => const RegisterPage());
      
      case profileSetup:
      return MaterialPageRoute(builder: (_) => const _ProfileSetupPage());
      
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const _EmailVerificationPage());
      
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const _ResetPasswordPage());

      case main:
        return MaterialPageRoute(builder: (_) => const MainPage());

      case diaryList:
        return MaterialPageRoute(builder: (_) => const DiaryListPage());

      case diaryWrite:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DiaryWritePage(
            editingDiary: args?['diary'],
          ),
        );

      case diaryDetail:
        final diaryId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DiaryDetailPage(diaryId: diaryId),
        );

      case matching:
        return MaterialPageRoute(builder: (_) => const MatchingPage());

      case chatList:
        return MaterialPageRoute(builder: (_) => const ChatListPage());

      case chatDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => _ChatDetailPage(
            chatRoomId: args['chatRoomId'],
            partnerName: args['partnerName'],
          ),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case apiTest:
        return MaterialPageRoute(builder: (_) => const ApiConnectionTestPage());

      case fullApiTest:
        return MaterialPageRoute(builder: (_) => const FullApiTestPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}

// 임시 페이지들
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
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
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'AI Diary Matching',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSetupPage extends StatelessWidget {
  const _ProfileSetupPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: const Center(
        child: Text('프로필 설정 페이지\n구현 예정'),
      ),
    );
  }
}

class _EmailVerificationPage extends StatelessWidget {
  const _EmailVerificationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이메일 인증')),
      body: const Center(
        child: Text('이메일 인증 페이지\n구현 예정'),
      ),
    );
  }
}

class _ResetPasswordPage extends StatelessWidget {
  const _ResetPasswordPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 재설정')),
      body: const Center(
        child: Text('비밀번호 재설정 페이지\n구현 예정'),
      ),
    );
  }
}

class _ChatDetailPage extends StatelessWidget {
  final String chatRoomId;
  final String partnerName;

  const _ChatDetailPage({
    required this.chatRoomId,
    required this.partnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(partnerName)),
      body: const Center(
        child: Text('채팅 상세 페이지\n구현 예정'),
      ),
    );
  }
}
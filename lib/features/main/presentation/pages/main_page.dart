import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../diary/presentation/pages/diary_list_page.dart';
import '../../../diary/presentation/pages/diary_write_page.dart';
import '../../../matching/presentation/pages/matching_page.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../providers/navigation_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DiaryListPage(),     // 0: 일기
          MatchingPage(),      // 1: 매칭
          ChatListPage(),      // 2: 채팅
          ProfilePage(),       // 3: 프로필
        ],
      ),

      // 플로팅 액션 버튼 (일기 작성)
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DiaryWritePage(),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('일기 쓰기'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // 하단 네비게이션 바
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(navigationProvider.notifier).setIndex(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.outline,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: [
            BottomNavigationBarItem(
              icon: _NavigationIcon(
                icon: Icons.book_outlined,
                activeIcon: Icons.book,
                isActive: currentIndex == 0,
              ),
              label: '일기',
            ),
            BottomNavigationBarItem(
              icon: _NavigationIcon(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                isActive: currentIndex == 1,
              ),
              label: '매칭',
            ),
            BottomNavigationBarItem(
              icon: _NavigationIcon(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                isActive: currentIndex == 2,
              ),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: _NavigationIcon(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isActive: currentIndex == 3,
              ),
              label: '프로필',
            ),
          ],
        ),
      ),
    );
  }
}

// 네비게이션 아이콘 위젯
class _NavigationIcon extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;

  const _NavigationIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        isActive ? activeIcon : icon,
        key: ValueKey(isActive),
      ),
    );
  }
}
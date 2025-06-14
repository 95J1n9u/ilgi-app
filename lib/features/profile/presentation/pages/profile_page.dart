import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../app/routes/app_routes.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 프로필 헤더
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 프로필 이미지
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: authState.userProfile?.profileImageUrl != null
                            ? NetworkImage(authState.userProfile!.profileImageUrl!)
                            : null,
                        child: authState.userProfile?.profileImageUrl == null
                            ? Icon(
                          Icons.person,
                          size: 40,
                          color: colorScheme.primary,
                        )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      // 이름
                      Text(
                        authState.userProfile?.name ?? '사용자',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 나이
                      if (authState.userProfile?.age != null)
                        Text(
                          '${authState.userProfile!.age}세',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // 설정 페이지
                },
              ),
            ],
          ),

          // 메뉴 항목들
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AI 분석 결과
                _MenuCard(
                  icon: Icons.psychology,
                  title: 'AI 성격 분석',
                  subtitle: '나의 성격과 감정 패턴을 확인해보세요',
                  onTap: () {
                    // AI 분석 결과 페이지
                  },
                ),

                const SizedBox(height: 12),

                // 프로필 편집
                _MenuCard(
                  icon: Icons.edit,
                  title: '프로필 편집',
                  subtitle: '개인정보와 관심사를 수정하세요',
                  onTap: () {
                    // 프로필 편집 페이지
                  },
                ),

                const SizedBox(height: 12),

                // 매칭 설정
                _MenuCard(
                  icon: Icons.tune,
                  title: '매칭 설정',
                  subtitle: '선호하는 상대의 조건을 설정하세요',
                  onTap: () {
                    // 매칭 설정 페이지
                  },
                ),

                const SizedBox(height: 12),

                // 개인정보 보호
                _MenuCard(
                  icon: Icons.security,
                  title: '개인정보 보호',
                  subtitle: '데이터 사용 및 공개 범위를 설정하세요',
                  onTap: () {
                    // 개인정보 설정 페이지
                  },
                ),

                const SizedBox(height: 24),

                // 기타 메뉴
                _MenuSection(
                  title: '기타',
                  children: [
                    _MenuListTile(
                      icon: Icons.help,
                      title: '도움말',
                      onTap: () {},
                    ),
                    _MenuListTile(
                      icon: Icons.feedback,
                      title: '피드백 보내기',
                      onTap: () {},
                    ),
                    _MenuListTile(
                      icon: Icons.info,
                      title: '앱 정보',
                      onTap: () {},
                    ),
                    const Divider(),
                    _MenuListTile(
                      icon: Icons.api,
                      title: 'API 연결 테스트 (기본)',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.apiTest);
                      },
                    ),
                    _MenuListTile(
                      icon: Icons.integration_instructions,
                      title: '전체 API 테스트',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.fullApiTest);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 로그아웃 버튼
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('로그아웃'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Firebase Auth 직접 로그아웃 (더 확실하게)
              await FirebaseAuth.instance.signOut();
              
              // AuthWrapper가 자동으로 로그인 페이지로 이동시킴
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('로그아웃되었습니다!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}

// 메뉴 카드 위젯
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
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
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 메뉴 섹션 위젯
class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MenuSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}

// 메뉴 리스트 타일 위젯
class _MenuListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
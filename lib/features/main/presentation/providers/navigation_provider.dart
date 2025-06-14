import 'package:flutter_riverpod/flutter_riverpod.dart';

// 네비게이션 인덱스 상태 관리
class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    if (index >= 0 && index <= 3) {
      state = index;
    }
  }

  void goToDiary() => setIndex(0);
  void goToMatching() => setIndex(1);
  void goToChat() => setIndex(2);
  void goToProfile() => setIndex(3);
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});
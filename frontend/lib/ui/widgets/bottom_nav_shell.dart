import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'add_item_sheet.dart';
import 'app_bottom_tab_bar.dart';

/// 하단 네비게이션 셸 위젯
class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavShell({
    super.key,
    required this.navigationShell,
  });

  /// 탭 인덱스를 브랜치 인덱스로 매핑
  /// BottomNavigationBar: [0: 홈, 1: 관심, 2: + 버튼, 3: 혜택, 4: 마이]
  /// Branches: [0: 홈, 1: 관심, 2: 혜택, 3: 마이]
  int _mapTabIndexToBranchIndex(int tabIndex) {
    if (tabIndex == 2) {
      // 중앙 + 버튼 - bottom sheet 표시
      return -1;
    } else if (tabIndex == 3) {
      // 혜택 탭 -> 브랜치 인덱스 2
      return 2;
    } else if (tabIndex == 4) {
      // 마이 탭 -> 브랜치 인덱스 3
      return 3;
    }
    // 홈(0) -> 브랜치 0, 관심(1) -> 브랜치 1
    return tabIndex;
  }

  /// 브랜치 인덱스를 탭 인덱스로 매핑
  int _mapBranchIndexToTabIndex(int branchIndex) {
    if (branchIndex == 2) {
      return 3; // 혜택 브랜치 -> 탭 인덱스 3
    } else if (branchIndex == 3) {
      return 4; // 마이 브랜치 -> 탭 인덱스 4
    }
    return branchIndex; // 홈(0), 관심(1)은 동일
  }

  void _onTabTapped(int index, BuildContext context) {
    if (index == 2) {
      // + 버튼 클릭 시 bottom sheet 표시
      _onFabTapped(context);
      return;
    }
    
    final branchIndex = _mapTabIndexToBranchIndex(index);
    if (branchIndex == -1) {
      return;
    }
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  void _onFabTapped(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddItemSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = _mapBranchIndexToTabIndex(navigationShell.currentIndex);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: AppBottomTabBar(
        currentIndex: currentTabIndex,
        onTap: (index) => _onTabTapped(index, context),
        onFabTap: () => _onFabTapped(context),
      ),
    );
  }
}

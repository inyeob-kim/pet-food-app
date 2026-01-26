import 'route_paths.dart';

/// 네비게이션 셸 유틸리티
/// 탭 인덱스와 경로 간 매핑 관리
class NavShell {
  /// 탭 인덱스 정의
  static const int homeIndex = 0;
  static const int watchIndex = 1;
  static const int meIndex = 2;
  
  /// 전체 탭 경로 리스트
  static const List<String> tabPaths = [
    RoutePaths.home,
    RoutePaths.watch,
    RoutePaths.me,
  ];
  
  /// 경로에서 탭 인덱스 추출
  static int getTabIndexFromPath(String path) {
    if (path.startsWith(RoutePaths.home)) {
      return homeIndex;
    } else if (path.startsWith(RoutePaths.watch)) {
      return watchIndex;
    } else if (path.startsWith(RoutePaths.me)) {
      return meIndex;
    }
    return homeIndex; // 기본값
  }
  
  /// 탭 인덱스에서 경로 추출
  static String getPathFromTabIndex(int index) {
    if (index >= 0 && index < tabPaths.length) {
      return tabPaths[index];
    }
    return RoutePaths.home; // 기본값
  }
}


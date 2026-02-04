import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_paths.dart';
import '../../ui/widgets/bottom_nav_shell.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/data/repositories/onboarding_repository.dart';
import '../../features/pet_profile/presentation/screens/pet_profile_screen.dart';
import '../../features/home/presentation/screens/figma_home_screen.dart';
import '../../features/watch/presentation/screens/figma_watch_screen.dart';
import '../../features/benefits/presentation/screens/figma_benefits_screen.dart';
import '../../features/market/presentation/screens/figma_market_screen.dart';
import '../../features/me/presentation/screens/figma_my_screen.dart';
import '../../features/product_detail/presentation/screens/figma_product_detail_screen.dart';
import '../../onboarding_v2/onboarding_flow.dart';

// 루트 네비게이터 키 (바텀 탭 밖의 페이지용) - 전역으로 선언하여 접근 가능하게
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Provider (Riverpod과 연동)
final routerProvider = Provider<GoRouter>((ref) {
  return _createRouter(ref);
});

GoRouter _createRouter(Ref ref) {
  // 각 탭별 NavigatorKey 생성
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final watchNavigatorKey = GlobalKey<NavigatorState>();
  final marketNavigatorKey = GlobalKey<NavigatorState>();
  final benefitsNavigatorKey = GlobalKey<NavigatorState>();
  final meNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.onboarding,
    redirect: (context, state) async {
      final onboardingRepo = OnboardingRepositoryImpl();
      final isCompleted = await onboardingRepo.isOnboardingCompleted();
      final location = state.uri.path;

      // A) 온보딩 미완료 → 온보딩으로 리다이렉트
      if (!isCompleted) {
        if (location != RoutePaths.onboarding) {
          return RoutePaths.onboarding;
        }
        return null; // 이미 온보딩 화면이면 그대로
      }

      // B) 온보딩 완료 → 온보딩 화면 접근 시 홈으로 리다이렉트
      if (isCompleted && location == RoutePaths.onboarding) {
        return RoutePaths.home;
      }

      return null; // 리다이렉트 불필요
    },
    routes: [
      // 온보딩 라우트 (V2)
      GoRoute(
        path: RoutePaths.onboarding,
        name: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingFlowV2(),
      ),
      // 스플래시 스크린 (온보딩 완료 후)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.petProfile,
        name: RoutePaths.petProfile,
        builder: (context, state) => const PetProfileScreen(),
      ),
      
      // 메인 탭 ShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavShell(navigationShell: navigationShell);
        },
        branches: [
          // 홈 탭
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RoutePaths.home,
                builder: (context, state) => const FigmaHomeScreen(),
              ),
            ],
          ),
          // 관심 탭
          StatefulShellBranch(
            navigatorKey: watchNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.watch,
                name: RoutePaths.watch,
                builder: (context, state) => const FigmaWatchScreen(),
              ),
            ],
          ),
          // 검색/마켓 탭
          StatefulShellBranch(
            navigatorKey: marketNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.market,
                name: RoutePaths.market,
                builder: (context, state) => const FigmaMarketScreen(),
              ),
            ],
          ),
          // 혜택 탭
          StatefulShellBranch(
            navigatorKey: benefitsNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.benefits,
                name: RoutePaths.benefits,
                builder: (context, state) => const FigmaBenefitsScreen(),
              ),
            ],
          ),
          // 마이 탭
          StatefulShellBranch(
            navigatorKey: meNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.me,
                name: RoutePaths.me,
                builder: (context, state) => const FigmaMyScreen(),
              ),
            ],
          ),
        ],
      ),
      
      // 상세 화면 (탭 외부 - 루트 네비게이터 사용)
      GoRoute(
        path: RoutePaths.productDetail,
        name: RoutePaths.productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return FigmaProductDetailScreen(productId: productId);
        },
      ),
    ],
  );
}

/// AppRouter 클래스 (기존 호환성 유지)
/// 주의: Riverpod Provider를 사용해야 하므로 직접 사용하지 말고 routerProvider를 사용하세요
class AppRouter {
  // Deprecated: routerProvider를 사용하세요
  static GoRouter get router => throw UnimplementedError('routerProvider를 사용하세요');
}

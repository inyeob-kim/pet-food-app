import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../icons/app_icons.dart';

/// iOS 스타일 헤더 (DESIGN_GUIDE.md 기반)
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final bool showNotification;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const AppHeader({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.showNotification = true,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // 뒤로 가기 버튼
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBackTap ?? () {
                    // Navigator를 직접 사용하여 뒤로 가기
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      navigator.pop();
                    } else {
                      // Navigator로 pop이 안되면 GoRouter 사용
                      final router = GoRouter.of(context);
                      if (router.canPop()) {
                        router.pop();
                      }
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (showBackButton) const SizedBox(width: 8),
              // 타이틀 (더 크고 굵게)
              Text(
                title,
                style: AppTypography.h2.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // 알림 아이콘만
              if (showNotification)
                IconButton(
                  icon: AppIcons.bell(),
                  onPressed: onNotificationTap ?? () {
                    // TODO: 알림 화면 연결
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}

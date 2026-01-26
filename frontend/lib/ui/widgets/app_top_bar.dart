import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';

/// 공통 Top Bar 위젯 (쿠팡 스타일)
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final List<Widget>? actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onSettingsTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: AppTypography.titleLarge,
      ),
      titleSpacing: 0,
      actions: actions ??
          [
            // 알림 아이콘
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.iconPrimary,
              onPressed: onNotificationTap ?? () {
                // TODO: 알림 화면 연결
              },
            ),
            // 설정 아이콘
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: AppColors.iconPrimary,
              onPressed: onSettingsTap ?? () {
                // TODO: 설정 화면 연결
              },
            ),
            const SizedBox(width: 8),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

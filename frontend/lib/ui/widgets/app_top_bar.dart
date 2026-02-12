import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

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
      backgroundColor: Colors.white, // White background (DESIGN_GUIDE v2.2)
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.line, // #E5E7EB
          width: 1,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.h3.copyWith(
          color: AppColors.textPrimary, // #0F172A
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      titleSpacing: 0,
      iconTheme: IconThemeData(
        color: AppColors.textPrimary, // 헤더 아이콘은 Warm Dark Gray
      ),
      actions: actions ??
          [
            // 알림 아이콘
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.textPrimary, // 다크 차콜
              onPressed: onNotificationTap ?? () {
                // TODO: 알림 화면 연결
              },
            ),
            // 설정 아이콘
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: AppColors.textPrimary, // 다크 차콜
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

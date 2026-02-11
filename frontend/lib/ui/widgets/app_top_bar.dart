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
      backgroundColor: AppColors.headerGreen, // Deep Forest Green (DESIGN_GUIDE v2.1)
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          color: Colors.white, // 헤더는 흰색 텍스트
        ),
      ),
      titleSpacing: 0,
      iconTheme: const IconThemeData(
        color: Colors.white, // 헤더 아이콘은 흰색
      ),
      actions: actions ??
          [
            // 알림 아이콘
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: Colors.white, // 흰색
              onPressed: onNotificationTap ?? () {
                // TODO: 알림 화면 연결
              },
            ),
            // 설정 아이콘
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: Colors.white, // 흰색
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

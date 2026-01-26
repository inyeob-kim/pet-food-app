import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import 'icon_circle_button.dart';

/// 공통 Top Bar 위젯
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
      title: Text(title, style: AppTypography.titleLarge),
      actions: actions ??
          [
            if (onNotificationTap != null)
              IconCircleButton(
                icon: Icons.notifications_outlined,
                onPressed: onNotificationTap,
              ),
            if (onSettingsTap != null) ...[
              const SizedBox(width: 8),
              IconCircleButton(
                icon: Icons.settings_outlined,
                onPressed: onSettingsTap,
              ),
            ],
            const SizedBox(width: 8),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

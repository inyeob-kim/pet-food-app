import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 원형 아이콘 버튼 위젯
class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const IconCircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.transparent,
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: iconColor ?? AppColors.iconMuted,
          ),
        ),
      ),
    );
  }
}

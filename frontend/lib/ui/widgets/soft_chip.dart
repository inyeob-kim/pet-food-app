import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

/// Soft Chip 위젯
class SoftChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const SoftChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // DESIGN_GUIDE v2.2
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(AppRadius.pill), // 완전 둥근 CTA
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: textColor ?? AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


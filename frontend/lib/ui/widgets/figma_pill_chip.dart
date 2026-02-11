import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';

/// Pill Chip 위젯 (DESIGN_GUIDE.md v2.2)
/// 
/// radius pill, padding 6-8 vertical 10-12 horizontal
class FigmaPillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FigmaPillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // DESIGN_GUIDE v2.2
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryCoral // Warm Terracotta 또는 primary
                : AppColors.surfaceWarm, // 따뜻한 크림
            borderRadius: BorderRadius.circular(AppRadius.pill), // 완전 둥근 CTA
            border: selected
                ? null
                : Border.all(color: AppColors.line, width: 1),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: selected
                    ? Colors.white
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

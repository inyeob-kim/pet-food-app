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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // DESIGN_GUIDE v2.2
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary // Blue
              : const Color(0xFFF3F4F6), // Gray 100 - 회색 배경
          borderRadius: BorderRadius.circular(AppRadius.pill), // 완전 둥근 CTA
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary, // 회색 텍스트
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

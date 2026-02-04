import 'package:flutter/material.dart';
import '../../theme_v2/app_colors.dart';
import '../../theme_v2/app_typography.dart';

/// Pill chip component matching React implementation
class PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const PillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColorsV2.primary : AppColorsV2.background,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: AppTypographyV2.body.copyWith(
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColorsV2.textMain,
          ),
        ),
      ),
    );
  }
}

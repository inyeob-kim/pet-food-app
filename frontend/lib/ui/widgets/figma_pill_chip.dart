import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Pill Chip 위젯
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
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2563EB)
                : const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.small.copyWith(
                color: selected
                    ? Colors.white
                    : const Color(0xFF111827),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

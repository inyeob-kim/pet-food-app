import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';

/// Selection card component - DESIGN_GUIDE v1.0 준수
class SelectionCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final String? emoji;

  const SelectionCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryLight // #EFF6FF (Light Blue)
              : AppColors.surface, // White
          borderRadius: BorderRadius.circular(AppRadius.card), // rounded-2xl (16px)
          border: Border.all(
            color: selected
                ? AppColors.primary // #2563EB
                : AppColors.border, // #E5E7EB (Gray 200)
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryLighter // #DBEAFE
                      : AppColors.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(
                  emoji!,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: child,
            ),
            const SizedBox(width: AppSpacing.md),
            // Checkmark (design.mdc: rounded-full, #DBEAFE background)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AppColors.primaryLighter // #DBEAFE
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : AppColors.border,
                  width: selected ? 0 : 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.primary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

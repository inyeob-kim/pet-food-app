import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';

/// CTA Button component - DESIGN_GUIDE v1.0 준수
class PrimaryCTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isSecondary;

  const PrimaryCTAButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      // Secondary Button (design.mdc: transparent background, border)
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: disabled
                ? AppColors.textSecondary
                : AppColors.textSecondary, // #475569
            side: BorderSide(
              color: disabled
                  ? AppColors.border
                  : AppColors.border, // border-gray-200
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button), // rounded-xl (12px)
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.primaryLight.withOpacity(0.1); // hover:bg-gray-50
                }
                return null;
              },
            ),
          ),
          child: Text(
            text,
            style: AppTypography.button.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600, // font-semibold
              color: disabled
                  ? AppColors.textSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    // Primary Button (design.mdc: #2563EB, rounded-xl, shadow-lg)
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.button), // rounded-xl (12px)
        boxShadow: disabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? AppColors.border : AppColors.primary, // #2563EB
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button), // rounded-xl (12px)
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.1);
              }
              return null;
            },
          ),
        ),
        child: Text(
          text,
          style: AppTypography.button.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600, // font-semibold
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

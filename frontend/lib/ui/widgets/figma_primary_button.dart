import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Primary Button 위젯
class FigmaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool disabled;

  const FigmaPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || onPressed == null;

    if (variant == ButtonVariant.small) {
      return SizedBox(
        height: 36,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? AppColors.background
                : AppColors.primaryBlue, // Calm Blue 통일
            foregroundColor: isDisabled
                ? AppColors.textSecondary
                : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTypography.small.copyWith(
              color: isDisabled
                  ? AppColors.textSecondary
                  : Colors.white,
            ),
          ),
        ),
      );
    }

    if (variant == ButtonVariant.secondary) {
      return SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTypography.body,
          ),
        ),
      );
    }

    // Primary variant
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? const Color(0xFFF7F8FA)
              : const Color(0xFF2563EB),
          foregroundColor: isDisabled
              ? const Color(0xFF6B7280)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTypography.body.copyWith(
            color: isDisabled
                ? AppColors.textSecondary
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

enum ButtonVariant {
  primary,
  secondary,
  small,
}

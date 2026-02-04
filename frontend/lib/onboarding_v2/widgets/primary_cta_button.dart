import 'package:flutter/material.dart';
import '../../theme_v2/app_colors.dart';
import '../../theme_v2/app_typography.dart';

/// CTA Button component matching React implementation
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
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColorsV2.surface,
            foregroundColor: AppColorsV2.textMain,
            side: BorderSide(
              color: disabled ? AppColorsV2.divider : AppColorsV2.divider,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: AppTypographyV2.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? AppColorsV2.divider : AppColorsV2.primary,
          foregroundColor: disabled ? AppColorsV2.textSub : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTypographyV2.body.copyWith(
            fontWeight: FontWeight.w600,
            color: disabled ? AppColorsV2.textSub : Colors.white,
          ),
        ),
      ),
    );
  }
}

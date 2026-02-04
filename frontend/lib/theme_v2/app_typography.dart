import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system for onboarding_v2 (Toss-inspired)
/// Matches figma_make_react typography
class AppTypographyV2 {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontFamilyFallback: const ['NotoSansKR', 'Apple SD Gothic Neo', 'Roboto'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColorsV2.textMain,
      letterSpacing: letterSpacing ?? -0.3,
      height: height ?? 1.4,
    );
  }

  // Hero: 38px, Bold, -0.5 letter spacing
  static TextStyle hero = _base(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // Title: 23px, SemiBold, -0.4 letter spacing
  static TextStyle title = _base(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.3,
  );

  // Body: 17px, Medium, -0.3 letter spacing
  static TextStyle body = _base(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  // Sub: 14px, Regular, -0.3 letter spacing
  static TextStyle sub = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorsV2.textSub,
    letterSpacing: -0.3,
  );

  // Small: 12px, Regular
  static TextStyle small = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsV2.textSub,
  );
}

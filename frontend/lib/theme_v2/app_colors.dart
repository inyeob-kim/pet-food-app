import 'package:flutter/material.dart';

/// Design tokens for onboarding_v2 (Toss-inspired)
/// Matches figma_make_react color system
class AppColorsV2 {
  // Primary (Teal - 2026 업데이트)
  static const Color primaryTeal = Color(0xFF0EA5E9); // Teal, 신뢰 + 건강
  static const Color primaryTealDark = Color(0xFF0C7A9E); // 호버/활성 상태
  
  // 호환성을 위한 별칭
  static const Color primary = primaryTeal;
  static const Color primaryDark = primaryTealDark;
  static const Color primarySoft = Color(0xFFE0F2FE); // Teal 50

  // Text
  static const Color textMain = Color(0xFF111827);
  static const Color textSub = Color(0xFF6B7280);

  // Status
  static const Color petGreen = Color(0xFF10B981); // soft emerald, 안심 신호
  static const Color petGreenLight = Color(0xFFE6F4EA); // opacity 0.1~0.2 배경용
  static const Color positive = petGreen;
  static const Color negative = Color(0xFFEF4444);

  // Background & Surface
  static const Color background = Color(0xFFFDFAF7); // Warm Off-White, 2026 comfort-driven 표준
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFFEFEFC); // 연한 베이지, 일부 카드에 옵션 사용

  // Border & Divider
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE5E7EB);
}

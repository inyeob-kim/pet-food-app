import 'package:flutter/material.dart';

/// 앱 Shadow 정의 (DESIGN_GUIDE.md v4.1 - Premium Shadow System)
/// 
/// 미세한 Shadow 사용 (Premium 느낌)
/// - 기본 카드: 0 2px 6px rgba(0,0,0,0.03)
/// - BottomSheet: blurRadius 12, opacity 0.06
/// - Floating CTA: opacity 0.03~0.05
class AppShadows {
  // 기본 카드 shadow (Premium 느낌)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x08000000), // rgba(0, 0, 0, 0.03)
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  // BottomSheet (예외적 사용)
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0, 0, 0, 0.06)
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // Floating CTA (미세한 shadow)
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x08000000), // rgba(0, 0, 0, 0.03)
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  // Modal (예외적 사용)
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0, 0, 0, 0.06)
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // Legacy (호환성 - 사용 권장하지 않음)
  @Deprecated('card shadow 사용')
  static const List<BoxShadow> minimal = card;
  
  // AI 마크 (유지)
  static const List<BoxShadow> aiMark = [
    BoxShadow(
      color: Color(0x2E7C3AED), // rgba(124, 58, 237, 0.18)
      blurRadius: 22,
      offset: Offset(0, 10),
      spreadRadius: 0,
    ),
  ];
}

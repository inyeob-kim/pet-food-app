import 'package:flutter/material.dart';

/// 앱 Shadow 정의 (HeyGeno Landing Style)
/// 
/// HeyGeno Landing 디자인 시스템 기반 Shadow
/// - 기본 카드: shadow-sm (0 1px 3px rgba(0,0,0,0.1))
/// - 호버 카드: shadow-md (0 4px 6px rgba(0,0,0,0.1))
/// - 버튼: shadow-lg (0 10px 15px rgba(0,0,0,0.1))
class AppShadows {
  // 기본 카드 shadow (shadow-sm - HeyGeno Landing)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
      blurRadius: 3,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
  
  // 호버 카드 shadow (shadow-md - HeyGeno Landing)
  static const List<BoxShadow> cardHover = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];
  
  // 버튼 shadow (shadow-lg - HeyGeno Landing)
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
  ];
  
  // 버튼 호버 shadow (shadow-xl - HeyGeno Landing)
  static const List<BoxShadow> buttonHover = [
    BoxShadow(
      color: Color(0x40000000), // rgba(0, 0, 0, 0.25)
      blurRadius: 25,
      offset: Offset(0, 20),
      spreadRadius: -5,
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

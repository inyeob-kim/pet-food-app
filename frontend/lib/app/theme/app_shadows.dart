import 'package:flutter/material.dart';

/// 앱 Shadow 정의 (DESIGN_GUIDE.md v2.1 - Shadow 거의 사용 안 함)
/// 
/// The Farmer's Dog 스타일: Shadow 대신 얇은 border 또는 배경 대비로 구분
/// 허용 shadow: blur 12px, opacity 0.04, offset 0,4px
class AppShadows {
  // 허용 shadow (예외적 사용만): blur 12px, opacity 0.04, offset 0,4px
  static const List<BoxShadow> minimal = [
    BoxShadow(
      color: Color(0x0A0F172A), // rgba(15, 23, 42, 0.04)
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // 모달/바텀시트 (예외적 사용)
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x0A0F172A), // rgba(15, 23, 42, 0.04) - 최소화
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // Legacy (호환성 - 사용 권장하지 않음)
  @Deprecated('Shadow 사용을 피하고 border로 구분하세요')
  static const List<BoxShadow> card = [];
  
  @Deprecated('Shadow 사용을 피하고 border로 구분하세요')
  static const List<BoxShadow> button = [];
  
  @Deprecated('Shadow 사용을 피하고 border로 구분하세요')
  static const List<BoxShadow> small = [];
  
  @Deprecated('Shadow 사용을 피하고 border로 구분하세요')
  static const List<BoxShadow> medium = [];
  
  @Deprecated('Shadow 사용을 피하고 border로 구분하세요')
  static const List<BoxShadow> large = [];
  
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

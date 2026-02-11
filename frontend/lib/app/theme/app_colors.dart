import 'package:flutter/material.dart';

/// 앱 색상 정의 (DESIGN_GUIDE.md v2.1 - The Farmer's Dog Color & Tone Inspired)
class AppColors {
  // 배경 – The Farmer's Dog 전체 베이스 톤
  static const Color background = Color(0xFFFDFAF5); // Warm Cream / Off-White (#FDFAF5 ~ #FEFCFA)
  
  // 카드 / Surface – 살짝 더 밝은 크림
  static const Color surface = Color(0xFFFFFFFF); // #FFFFFF
  static const Color surfaceWarm = Color(0xFFFEF9F3); // 연한 베이지-크림, 카드 배경 추천
  
  // 텍스트
  static const Color textPrimary = Color(0xFF1F2A2F); // 따뜻한 다크 차콜
  static const Color textSecondary = Color(0xFF5C6B74); // muted gray-green
  
  // 헤더 / 네비게이션 – The Farmer's Dog 상단 그린
  static const Color headerGreen = Color(0xFF1A3C34); // Deep Forest Green (#1A3C34 ~ #0F2E26)
  
  // Primary CTA / 결정 버튼 – The Farmer's Dog 주요 버튼 색상
  static const Color primaryCoral = Color(0xFFE07A5F); // Warm Terracotta / Muted Coral (#E07A5F ~ #D65A3F)
  
  // 상태 / 안심 신호 – The Farmer's Dog가 주는 "건강함" 느낌에 가까운 그린
  static const Color petGreen = Color(0xFF4A8F6E); // Muted Olive Green (#3A7D5E ~ #4A8F6E)
  static const Color petGreenLight = Color(0xFF4A8F6E); // 배경용 (opacity 0.08~0.12)
  
  // Accent / 포인트 (제한적 사용)
  static const Color accentWarm = Color(0xFFF4A261); // Gentle Warm Orange, 혜택·최저가 알림에만
  
  // 상태 색상
  static const Color positive = Color(0xFF4A8F6E); // 안심 그린
  static const Color caution = Color(0xFFF4A261); // 주의 오렌지
  static const Color danger = Color(0xFFC2410C); // 따뜻한 레드, 과하지 않게
  
  // Border
  static const Color borderSoft = Color(0xFFE5E7EB); // 얇은 회색 border
  
  // 호환성을 위한 별칭 (기존 코드와의 호환성 유지)
  static const Color primary = primaryCoral; // 버튼 통일용 (Coral로 변경)
  static const Color primary2 = Color(0xFFD65A3F); // 호버/활성 상태 (더 진한 Coral)
  static const Color primaryDark = primary2;
  static const Color primaryLight = Color(0xFFE07A5F); // Coral 기본
  static const Color primarySoft = Color(0xFFFEF9F3); // 배경용 (surfaceWarm)
  
  // Legacy Blue (호환성 - 점진적 제거 예정)
  static const Color primaryBlue = Color(0xFF1E4ED8); // @deprecated - primaryCoral 사용 권장
  static const Color primaryBlueSoft = Color(0xFFE8EEFB); // @deprecated
  
  // Divider
  static const Color divider = borderSoft; // --line: #e5e7eb (Gray 200)
  
  // Status (Legacy 호환성)
  static const Color positiveGreen = positive;
  static const Color dangerRed = danger;
  
  // Icon
  static const Color iconMuted = textSecondary;
  static const Color iconPrimary = textPrimary;
  
  // BottomNav
  static const Color bottomNavInactive = textSecondary;
  static const Color bottomNavActive = headerGreen; // 헤더 그린 사용
  
  // FAB
  static const Color fabBackground = primaryCoral; // Coral 사용
  
  // Card
  static const Color cardBackground = surfaceWarm; // 따뜻한 크림 사용
  
  // Chip/Badge
  static const Color chipBackground = Color(0xFFFEF9F3); // 따뜻한 크림 배경
  static const Color chipText = textPrimary;
  
  // AI Colors (유지)
  static const Color ai = Color(0xFF7C3AED); // --ai: #7c3aed (Violet 600)
  static const Color ai2 = Color(0xFF6D28D9); // --ai2: #6d28d9 (Violet 700)
  static const Color aiChip = Color(0xFFF3E8FF); // --aiChip: #f3e8ff (Violet 100)
  static const Color aiChipText = Color(0xFF4C1D95); // Violet 900
  
  // Border with opacity
  static Color primaryBorder = primaryCoral.withOpacity(0.18); // Coral with opacity
  static Color aiBorder = const Color(0xFF7C3AED).withOpacity(0.18); // rgba(124, 58, 237, 0.18)
  static Color aiBorderStrong = const Color(0xFF7C3AED).withOpacity(0.22); // rgba(124, 58, 237, 0.22)
  
  // Legacy (호환성)
  static const Color textMuted = textSecondary;
  static const Color error = danger;
  static const Color success = positive;
}

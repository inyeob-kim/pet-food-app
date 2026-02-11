import 'package:flutter/material.dart';

/// 앱 색상 정의 (DESIGN_GUIDE.md v2.2 - 쌤대신 구조 + 헤이제노 감성 통합)
class AppColors {
  // 배경
  static const Color background = Color(0xFFFFFFFF); // White (화면 배경)
  static const Color surface = Color(0xFFFFFFFF); // #FFFFFF
  static const Color surfaceWarm = Color(0xFFFEF9F3); // 연한 베이지-크림, 카드 기본
  
  // 텍스트
  static const Color textPrimary = Color(0xFF1F2937); // Warm Dark Gray
  static const Color textSecondary = Color(0xFF64748B); // Muted Gray
  
  // 경계선
  static const Color line = Color(0xFFE5E7EB); // Gray 200, 부드러운 구분선
  static const Color borderSoft = line; // 별칭
  
  // 버튼 / 액션
  static const Color primary = Color(0xFF14B8A6); // Soft Teal – 결정/이동
  static const Color primaryDark = Color(0xFF0F766E); // 호버/활성
  static const Color primaryCoral = Color(0xFFE07A5F); // Warm Terracotta – 주요 CTA 버튼
  
  // 상태 / 안심
  static const Color petGreen = Color(0xFF10B981); // Warm Emerald – 안심 신호
  static const Color petGreenLight = Color(0xFFECFDF5); // opacity 배경용
  
  // Accent / 포인트 (제한적 사용)
  static const Color accentWarm = Color(0xFFF4A261); // Gentle Warm Orange, 혜택·최저가 알림에만
  
  // 상태 색상
  static const Color positive = Color(0xFF10B981); // 안심 그린
  static const Color caution = Color(0xFFF4A261); // 주의 오렌지
  static const Color danger = Color(0xFFC2410C); // 따뜻한 레드, 과하지 않게
  
  // 호환성을 위한 별칭 (기존 코드와의 호환성 유지)
  static const Color primary2 = primaryDark; // 호버/활성 상태
  static const Color primaryLight = primary; // Soft Teal 기본
  static const Color primarySoft = surfaceWarm; // 배경용
  
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
  static const Color bottomNavActive = primaryCoral; // Warm Terracotta 또는 primary
  
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

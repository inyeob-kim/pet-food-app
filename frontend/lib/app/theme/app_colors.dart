import 'package:flutter/material.dart';

/// 앱 색상 정의 (DESIGN_GUIDE.md 기반)
class AppColors {
  // Background
  static const Color background = Color(0xFFFDF8F3); // Warm Cream (DESIGN_GUIDE v1.1)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFFFFDF9);
  
  // Brand / Navigation (Calm Blue - DESIGN_GUIDE v1.1)
  static const Color primaryBlue = Color(0xFF1E4ED8); // Calm Blue, 브랜드/결정/이동
  static const Color primaryBlueSoft = Color(0xFFE8EEFB); // Tint
  
  // Sub Primary
  static const Color primaryTeal = Color(0xFF2BB0ED); // 보조 CTA
  
  // 호환성을 위한 별칭 (기존 코드와의 호환성 유지)
  static const Color primary = primaryBlue; // 버튼 통일용
  static const Color primary2 = Color(0xFF1D3FB8); // 호버/활성 상태
  static const Color primaryDark = primary2;
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primarySoft = primaryBlueSoft; // 배경용
  
  // Text
  static const Color textPrimary = Color(0xFF0F172A); // --text: #0f172a (Slate 900)
  static const Color textSecondary = Color(0xFF64748B); // --muted: #64748b (Slate 500)
  
  // Divider
  static const Color divider = Color(0xFFE5E7EB); // --line: #e5e7eb (Gray 200)
  
  // Status
  static const Color positiveGreen = Color(0xFF00D084);
  static const Color dangerRed = Color(0xFFF04452);
  
  // Pet Green (Status / Emotional - 현재 상태, 안심, 성공)
  static const Color petGreen = Color(0xFF10B981); // soft emerald, 안심 신호
  static const Color petGreenLight = Color(0xFFE6F4EA); // opacity 0.1~0.2 배경용
  
  // Icon
  static const Color iconMuted = textSecondary;
  static const Color iconPrimary = textPrimary;
  
  // BottomNav
  static const Color bottomNavInactive = textSecondary;
  static const Color bottomNavActive = primary;
  
  // FAB
  static const Color fabBackground = primary;
  
  // Card
  static const Color cardBackground = surface;
  
  // Chip/Badge
  static const Color chipBackground = Color(0xFFEEF2FF); // --chip: #eef2ff (Blue 100)
  static const Color chipText = Color(0xFF1E3A8A); // Blue 900
  
  // AI Colors
  static const Color ai = Color(0xFF7C3AED); // --ai: #7c3aed (Violet 600)
  static const Color ai2 = Color(0xFF6D28D9); // --ai2: #6d28d9 (Violet 700)
  static const Color aiChip = Color(0xFFF3E8FF); // --aiChip: #f3e8ff (Violet 100)
  static const Color aiChipText = Color(0xFF4C1D95); // Violet 900
  
  // Border with opacity (DESIGN_GUIDE v1.1 - Calm Blue)
  static Color primaryBorder = const Color(0xFF1E4ED8).withOpacity(0.18); // Calm Blue with opacity
  static Color aiBorder = const Color(0xFF7C3AED).withOpacity(0.18); // rgba(124, 58, 237, 0.18)
  static Color aiBorderStrong = const Color(0xFF7C3AED).withOpacity(0.22); // rgba(124, 58, 237, 0.22)
  
  // Legacy (호환성)
  static const Color textMuted = textSecondary;
  static const Color error = dangerRed;
  static const Color success = positiveGreen;
}

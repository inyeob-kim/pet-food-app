import 'package:flutter/material.dart';

/// 디자인 토큰: 색상 (토스 스타일)
/// 카드/구분선 없이도 정보 위계가 보이게 하는 숫자 중심 UI
class AppColors {
  // Background
  static const Color background = Color(0xFFFDF8F3); // Warm Cream (DESIGN_GUIDE v1.1)
  static const Color bg = background; // 별칭
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFFFFDF9);
  
  // Brand / Navigation (Calm Blue - DESIGN_GUIDE v1.1)
  static const Color primaryBlue = Color(0xFF1E4ED8); // Calm Blue, 브랜드/결정/이동
  static const Color primaryBlueSoft = Color(0xFFE8EEFB); // Tint
  
  // Sub Primary
  static const Color primaryTeal = Color(0xFF2BB0ED); // 보조 CTA
  
  // 호환성을 위한 별칭
  static const Color primary = primaryBlue; // 버튼 통일용
  static const Color primaryDark = Color(0xFF1D3FB8); // 호버/활성 상태
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primarySoft = primaryBlueSoft; // 배경용
  
  // Text (정보 위계)
  static const Color textMain = Color(0xFF111827); // 메인 텍스트 (숫자/핵심 정보)
  static const Color textSub = Color(0xFF6B7280); // 보조 텍스트
  static const Color textTertiary = Color(0xFF9CA3AF); // 3차 텍스트
  
  // Legacy (하위 호환)
  static const Color textPrimary = textMain;
  static const Color textSecondary = textSub;
  
  // Status (판단 정보)
  static const Color petGreen = Color(0xFF10B981); // soft emerald, 안심 신호
  static const Color petGreenLight = Color(0xFFE6F4EA); // opacity 0.1~0.2 배경용
  static const Color positive = petGreen; // 긍정/저렴
  static const Color negative = Color(0xFFEF4444); // 부정/비쌈
  static const Color success = positive;
  static const Color danger = negative;
  
  // Divider (사용 금지 원칙, 하지만 필요시 최소한으로)
  static const Color divider = Color(0xFFE5E7EB);
  
  // Chip
  static const Color chipBg = Color(0xFFF3F4F6);
  
  // Icon
  static const Color iconMuted = Color(0xFF6B7280);
  static const Color iconPrimary = textMain;
  
  // BottomNav
  static const Color bottomNavInactive = Color(0xFF6B7280);
  static const Color bottomNavActive = primary;
  
  // FAB
  static const Color fabBackground = primary;
}


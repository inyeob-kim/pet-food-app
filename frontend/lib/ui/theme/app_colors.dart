import 'package:flutter/material.dart';

/// 디자인 토큰: 색상 (토스 스타일)
/// 카드/구분선 없이도 정보 위계가 보이게 하는 숫자 중심 UI
class AppColors {
  // Background
  static const Color background = Color(0xFFF7F8FA); // 토스 스타일 배경 (아주 옅은 회색)
  static const Color bg = background; // 별칭
  static const Color surface = Color(0xFFFFFFFF); // 화이트 (필요시만)
  
  // Primary (행동/핵심 수치) - #2563EB
  static const Color primary = Color(0xFF2563EB); // 토스 스타일 Primary
  static const Color primaryBlue = primary; // 하위 호환성
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySoft = Color(0xFFEFF6FF);
  
  // Text (정보 위계)
  static const Color textMain = Color(0xFF111827); // 메인 텍스트 (숫자/핵심 정보)
  static const Color textSub = Color(0xFF6B7280); // 보조 텍스트
  static const Color textTertiary = Color(0xFF9CA3AF); // 3차 텍스트
  
  // Legacy (하위 호환)
  static const Color textPrimary = textMain;
  static const Color textSecondary = textSub;
  
  // Status (판단 정보)
  static const Color positive = Color(0xFF16A34A); // 긍정/저렴
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


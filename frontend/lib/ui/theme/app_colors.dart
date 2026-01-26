import 'package:flutter/material.dart';

/// 디자인 토큰: 색상 (토스 스타일)
class AppColors {
  // Background
  static const Color background = Color(0xFFF7F8FA); // 토스 밝은 회색
  static const Color surface = Color(0xFFFFFFFF); // 화이트
  
  // Primary (토스 블루)
  static const Color primaryBlue = Color(0xFF3182F6); // 토스 블루
  static const Color primary = primaryBlue;
  static const Color primaryDark = Color(0xFF1E6CE8);
  static const Color primaryLight = Color(0xFF5A9AFF);
  static const Color primarySoft = Color(0xFFE8F0FE);
  
  // Text
  static const Color textPrimary = Color(0xFF191F28); // 토스 다크 그레이
  static const Color textSecondary = Color(0xFF8B95A1); // 토스 라이트 그레이
  static const Color textTertiary = Color(0xFFB2B8C1);
  
  // Divider
  static const Color divider = Color(0xFFE5E8EB); // 얇은 구분선
  
  // Status
  static const Color positiveGreen = Color(0xFF00D084); // 토스 그린
  static const Color dangerRed = Color(0xFFF04452); // 토스 레드
  static const Color success = positiveGreen;
  static const Color danger = dangerRed;
  
  // Chip
  static const Color chipBg = Color(0xFFF2F4F6);
  
  // Icon
  static const Color iconMuted = Color(0xFF8B95A1);
  static const Color iconPrimary = textPrimary;
  
  // BottomNav
  static const Color bottomNavInactive = Color(0xFF8B95A1);
  static const Color bottomNavActive = primaryBlue;
  
  // FAB
  static const Color fabBackground = primaryBlue;
}


import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// 디자인 시스템: Theme (토스 스타일)
/// 카드/구분선 없이도 정보 위계가 보이게 하는 숫자 중심 UI
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      fontFamilyFallback: const ['NotoSansKR', 'Apple SD Gothic Neo', 'Roboto'],
      
      // ColorScheme (토스 스타일)
      colorScheme: ColorScheme.light(
        primary: AppColors.primary, // #2563EB
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.negative, // #EF4444
        onPrimary: Colors.white,
        onSurface: AppColors.textMain,
        onBackground: AppColors.textMain,
        // 추가 색상
        secondary: AppColors.positive, // #16A34A
        tertiary: AppColors.textSub, // #6B7280
      ),
      
      // Scaffold 배경색 통일 (토스 스타일 bg)
      scaffoldBackgroundColor: AppColors.bg,
      
      // Text Theme (토스 스타일 Typography)
      // 숫자/제목/본문/보조 텍스트 위계가 Theme만으로 일정해진다
      textTheme: TextTheme(
        // Hero: 36~40, 700 (핵심 수치)
        displayLarge: AppTypography.hero,
        displayMedium: AppTypography.hero,
        // Title: 22~24, 600 (섹션 제목)
        displaySmall: AppTypography.title,
        titleLarge: AppTypography.title,
        titleMedium: AppTypography.title,
        // Body: 16~18, 500 (본문 메인)
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.body,
        titleSmall: AppTypography.body,
        // Sub: 13~14, 400 (보조 텍스트)
        bodySmall: AppTypography.sub,
        labelSmall: AppTypography.sub,
        labelMedium: AppTypography.sub,
        labelLarge: AppTypography.sub,
      ),
      
      // AppBar (최소한의 스타일)
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title,
        iconTheme: const IconThemeData(
          color: AppColors.iconMuted,
        ),
      ),
      
      // Divider (사용 금지 원칙 - 화면에서 divider 제거 유도)
      dividerTheme: const DividerThemeData(
        color: Colors.transparent, // 기본적으로 숨김
        thickness: 0, // 두께 최소화
        space: 0,
      ),
      
      // Card (사용 금지 원칙 - 기본 카드 느낌 없애기)
      cardTheme: CardThemeData(
        color: Colors.transparent, // 배경 없음
        elevation: 0, // 그림자 없음
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(), // shape 제거 (기본 카드 느낌 없애기)
      ),
      
      // Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: AppTypography.bodyMain.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.bodyMain.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBg,
        labelStyle: AppTypography.bodySub,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pillRadius),
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

/// 앱 테마 정의 (DESIGN_GUIDE.md v4.1 - Data-Driven Premium Platform Edition)
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary, // Blue (#1D4ED8)
        surface: AppColors.surface, // White
        background: AppColors.background, // Premium Neutral (#F8F8F6)
        error: AppColors.drop, // Red
      ),
      scaffoldBackgroundColor: AppColors.background, // Premium Neutral (#F8F8F6)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface, // White background
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary, // #0F172A
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary, // #0F172A
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface, // White
        shadowColor: Colors.black.withOpacity(0.03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card), // 12px
          side: const BorderSide(
            color: AppColors.border, // #E5E7EB
            width: 1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider, // #F1F5F9
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Blue (#1D4ED8)
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24, // DESIGN_GUIDE v4.1: horizontal 24px
            vertical: 12, // vertical 12px
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button), // 12px
          ),
          elevation: 0, // Shadow 없음
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary, // Blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface, // White
        selectedItemColor: AppColors.primary, // Blue
        unselectedItemColor: AppColors.iconMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary, // Blue
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: AppColors.drop,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface, // White background (라이트 모드와 동일)
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(
            color: Color(0xFF2C2C2C),
            width: 1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2C2C2C),
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Blue
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary, // Blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primary, // Blue
        unselectedItemColor: AppColors.iconMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

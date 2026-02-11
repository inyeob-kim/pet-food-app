import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryCoral, // Warm Terracotta / Muted Coral
        surface: AppColors.surface,
        background: AppColors.background, // Warm Cream
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background, // Warm Cream
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerGreen, // Deep Forest Green
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white, // 헤더는 흰색 텍스트
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // 헤더 아이콘은 흰색
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Shadow 없음
        color: AppColors.surfaceWarm, // 따뜻한 크림
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card), // 16px
          side: const BorderSide(
            color: AppColors.borderSoft, // 얇은 회색 border
            width: 1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCoral, // Warm Terracotta
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 32, // DESIGN_GUIDE v2.1: horizontal 32px
            vertical: 16, // vertical 16px
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button), // 16px
          ),
          elevation: 0, // Shadow 없음
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryCoral, // Coral
        foregroundColor: Colors.white,
        elevation: 0, // Shadow 최소화
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background, // Warm Cream
        selectedItemColor: AppColors.headerGreen, // Deep Forest Green
        unselectedItemColor: AppColors.iconMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Shadow 없음
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryCoral, // Coral 유지
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerGreen, // Deep Forest Green
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Shadow 없음
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card), // 16px
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
          backgroundColor: AppColors.primaryCoral, // Coral
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button), // 16px
          ),
          elevation: 0, // Shadow 없음
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryCoral, // Coral
        foregroundColor: Colors.white,
        elevation: 0, // Shadow 최소화
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primaryCoral, // Coral
        unselectedItemColor: AppColors.iconMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Shadow 없음
      ),
    );
  }
}




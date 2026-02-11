import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary, // Soft Teal
        surface: AppColors.surface,
        background: Colors.white, // White
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: Colors.white, // White (화면 배경)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // White background
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary, // 따뜻한 다크 차콜
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary, // 헤더 아이콘은 다크 차콜
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Shadow 없음
        color: AppColors.surfaceWarm, // 따뜻한 크림
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card), // 12px
          side: const BorderSide(
            color: AppColors.line, // 얇은 회색 border
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
          backgroundColor: AppColors.primaryCoral, // Warm Terracotta 또는 primary
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24, // DESIGN_GUIDE v2.2: horizontal 24px
            vertical: 12, // vertical 12px
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button), // 12px
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
        backgroundColor: Colors.white, // White
        selectedItemColor: AppColors.primaryCoral, // Warm Terracotta 또는 primary
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
        backgroundColor: Colors.white, // White background
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary, // 따뜻한 다크 차콜
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary, // 헤더 아이콘은 다크 차콜
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




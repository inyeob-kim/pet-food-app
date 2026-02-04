import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// ThemeData for onboarding_v2
class AppThemeV2 {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      fontFamilyFallback: const ['NotoSansKR', 'Apple SD Gothic Neo', 'Roboto'],
      
      colorScheme: ColorScheme.light(
        primary: AppColorsV2.primary,
        surface: AppColorsV2.surface,
        background: AppColorsV2.background,
        error: AppColorsV2.negative,
        onPrimary: Colors.white,
        onSurface: AppColorsV2.textMain,
        onBackground: AppColorsV2.textMain,
      ),
      
      scaffoldBackgroundColor: AppColorsV2.background,
      
      textTheme: TextTheme(
        displayLarge: AppTypographyV2.hero,
        titleLarge: AppTypographyV2.title,
        bodyLarge: AppTypographyV2.body,
        bodyMedium: AppTypographyV2.body,
        bodySmall: AppTypographyV2.sub,
        labelSmall: AppTypographyV2.small,
      ),
    );
  }
}

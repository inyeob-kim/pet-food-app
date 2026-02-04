import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 디자인 토큰: 타이포그래피 (토스 스타일)
/// 숫자 중심 UI를 위한 Typography 스케일
class AppTypography {
  // Pretendard 폰트 기본 설정
  // Note: Pretendard 폰트 파일을 assets/fonts/에 추가하고 pubspec.yaml에 등록 필요
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontFamilyFallback: const ['NotoSansKR', 'Apple SD Gothic Neo', 'Roboto'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textMain,
      letterSpacing: letterSpacing ?? -0.3,
      height: height ?? 1.4,
    );
  }
  
  // Hero: 36~40, 700 (핵심 수치 강조)
  static TextStyle hero = _base(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  // HeroNumber (별칭)
  static TextStyle heroNumber = hero;
  
  // Title: 22~24, 600 (섹션 제목)
  static TextStyle title = _base(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
    letterSpacing: -0.4,
    height: 1.3,
  );
  
  // SectionTitle (별칭)
  static TextStyle sectionTitle = title;
  
  // Body: 16~18, 500 (본문 메인)
  static TextStyle body = _base(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textMain,
    letterSpacing: -0.2,
  );
  
  // BodyMain (별칭)
  static TextStyle bodyMain = body;
  
  // Sub: 13~14, 400 (보조 텍스트)
  static TextStyle sub = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
    letterSpacing: -0.1,
  );
  
  // BodySub (별칭)
  static TextStyle bodySub = sub;
  
  // Body2 (별칭 - 하위 호환)
  static TextStyle body2 = sub;
  
  // Legacy (하위 호환)
  static TextStyle titleLarge = sectionTitle;
  static TextStyle titleMedium = _base(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
    letterSpacing: -0.3,
  );
  static TextStyle caption = bodySub;
  
  // Price (숫자 강조용)
  static TextStyle priceNumeric = _base(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
    letterSpacing: -0.4,
    height: 1.2,
  );
}


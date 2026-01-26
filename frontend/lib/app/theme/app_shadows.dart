import 'package:flutter/material.dart';

/// 앱 Shadow 정의 (토스 스타일: 부드럽고 미묘한 그림자)
class AppShadows {
  // 작은 그림자 (카드, 버튼)
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x08000000), // 매우 미묘한 그림자
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  // 중간 그림자 (카드 hover, elevated)
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // 큰 그림자 (모달, bottom sheet)
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
  
  // 카드 그림자 (토스 스타일)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
}


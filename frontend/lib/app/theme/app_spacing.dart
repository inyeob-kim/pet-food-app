/// Spacing 토큰 시스템 (DESIGN_GUIDE.md v2.1 - The Farmer's Dog처럼 넉넉하게)
/// 
/// 이 프로젝트의 모든 간격은 다음 규칙을 따릅니다:
/// 
/// - sm(8): 아이콘-텍스트, 작은 요소 간 간격
/// - md(16): 섹션 내부 그룹 간격
/// - lg(24): 카드 내부 기본 (더 넓게)
/// - xl(32): 섹션 간 여백
/// - xxl(48): 섹션 간 큰 여백
/// 
/// 사용 예시:
/// ```dart
/// SizedBox(height: AppSpacing.md)  // 섹션 내부 그룹
/// SizedBox(width: AppSpacing.sm)   // 아이콘-텍스트 간격
/// EdgeInsets.all(AppSpacing.lg)  // 카드 padding (24px)
/// SizedBox(height: AppSpacing.xxl) // 섹션 간 큰 여백 (48px)
/// ```
class AppSpacing {
  AppSpacing._(); // 인스턴스 생성 방지

  // micro (호환성 - 거의 사용 안 함)
  static const double xs = 4;

  // element gap (icon-text, label-value)
  static const double sm = 8;

  // group gap (section 내부)
  static const double md = 16;

  // section gap (card 내부 기본, 더 넓게)
  static const double lg = 24;

  // page gap (섹션 간 여백)
  static const double xl = 32;

  // large page gap (섹션 간 큰 여백)
  static const double xxl = 48;
}

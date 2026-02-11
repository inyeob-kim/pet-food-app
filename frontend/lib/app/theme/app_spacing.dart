/// Spacing 토큰 시스템 (DESIGN_GUIDE.md v2.2 - 쌤대신 구조 + 헤이제노 감성)
/// 
/// 이 프로젝트의 모든 간격은 다음 규칙을 따릅니다:
/// 
/// - xs(4): micro (호환성)
/// - sm(8): element gap (icon-text, label-value)
/// - md(12): group gap (section 내부)
/// - lg(16): 카드 내부 기본
/// - xl(24): 섹션·카드 간
/// - xxl(32): 큰 여백
/// - xxxl(48): 큰 여백 (히어로·섹션 분리)
/// 
/// 사용 예시:
/// ```dart
/// SizedBox(height: AppSpacing.md)  // 섹션 내부 그룹 (12px)
/// SizedBox(width: AppSpacing.sm)   // 아이콘-텍스트 간격 (8px)
/// EdgeInsets.all(AppSpacing.xl)    // 카드 padding (24px)
/// SizedBox(height: AppSpacing.xxxl) // 섹션 분리 (48px)
/// ```
class AppSpacing {
  AppSpacing._(); // 인스턴스 생성 방지

  // micro (호환성)
  static const double xs = 4;

  // element gap (icon-text, label-value)
  static const double sm = 8;

  // group gap (section 내부)
  static const double md = 12;

  // 카드 내부 기본
  static const double lg = 16;

  // 섹션·카드 간
  static const double xl = 24;

  // 큰 여백
  static const double xxl = 32;

  // 큰 여백 (히어로·섹션 분리)
  static const double xxxl = 48;
}

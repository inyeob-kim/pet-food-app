/// 앱 Border Radius 정의 (DESIGN_GUIDE.md v2.2 - 쌤대신 구조 + 헤이제노 감성)
class AppRadius {
  AppRadius._(); // 인스턴스 생성 방지
  
  // DESIGN_GUIDE v2.2 규칙
  static const double sm = 8;     // 칩·배지
  static const double md = 12;    // 기본 카드·버튼 (헤이제노 기본)
  static const double lg = 16;    // 큰 카드·바텀시트
  static const double pill = 999; // 완전 둥근 CTA
  
  // Legacy (호환성)
  static const double small = sm;
  static const double medium = md;
  static const double large = lg;
  static const double xlarge = lg; // xl 제거, lg로 통일
  
  // Bottom Sheet
  static const double bottomSheet = lg;
  
  // Button
  static const double button = md; // 12px
  static const double buttonModal = md;
  static const double buttonPill = pill; // 완전한 둥근 모서리
  
  // Card
  static const double card = md; // 12px
  
  // Chip/Badge
  static const double chip = sm; // 8px
  static const double badge = sm;
  
  // FAB
  static const double fab = 28.0;
  
  // Panel
  static const double panel = lg;
  
  // Callout
  static const double callout = lg;
  
  // Media
  static const double media = 14.0;
  
  // Step Num
  static const double stepNum = 10.0;
  
  // Code
  static const double code = 8.0;
}

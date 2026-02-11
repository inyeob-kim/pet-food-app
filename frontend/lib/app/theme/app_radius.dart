/// 앱 Border Radius 정의 (DESIGN_GUIDE.md v2.1 - The Farmer's Dog처럼 부드럽지만 과하지 않게)
class AppRadius {
  AppRadius._(); // 인스턴스 생성 방지
  
  // DESIGN_GUIDE v2.1 규칙
  static const double sm = 8;   // 칩·배지
  static const double md = 16;   // 카드·버튼 기본 (The Farmer's Dog 느낌)
  static const double lg = 24;   // 큰 카드·바텀시트
  
  // Legacy (호환성)
  static const double small = sm;
  static const double medium = md;
  static const double large = lg;
  static const double xlarge = lg; // xl 제거, lg로 통일
  
  // Bottom Sheet
  static const double bottomSheet = lg;
  
  // Button
  static const double button = md; // 16px
  static const double buttonModal = md;
  static const double buttonPill = 999.0; // 완전한 둥근 모서리
  
  // Card
  static const double card = md; // 16px
  
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

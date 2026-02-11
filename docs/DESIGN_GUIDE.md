# 🎨 헤이제노 디자인 시스템 가이드 v2.2

> 쌤대신 구조 + 헤이제노 감성 통합 버전  
> 일상 관리형 펫 웰니스 앱을 위한 따뜻하고 안심되는 디자인 시스템  
> **목표**: "우리 아이를 가족처럼 챙기는" 느낌 그대로

---

## 📋 목차

0. 헤이제노 디자인 철학  
1. 디자인 토큰 (Design Tokens)  
2. 타이포그래피  
3. 간격 시스템  
4. AppRadius 가이드  
5. 그림자 & 효과 (헤이제노 버전)  
6. CardContainer & 기본 컨테이너 규칙  
7. 컴포넌트 스타일  
8. 홈 화면 전용 UI 원칙  
9. 반응형 디자인  
10. 애니메이션 & 트랜지션  
11. 최종 체크리스트  

---

## 0️⃣ 헤이제노 디자인 철학

### 앱의 본질

**"우리 아이의 매일을 조용히 지켜보고 안심하게 해주는 동반자"**

### 핵심 감성

- **Comfort & Reassurance** (안심과 위로)
- **Gentle Confidence** (부드러운 확신)
- **Warm Daily Care** (따뜻한 일상 돌봄)

### 시각 원칙

- 차분하지만 차갑지 않게 (Warm Neutrals + Soft Natural Accents)
- 귀엽지만 유치하지 않게
- 넉넉한 여백과 숨 쉴 수 있는 공간
- 장식보다 정보 신호 우선

### 금지 사항

- ❌ 화려한 효과
- ❌ 강한 대비
- ❌ 차가운 톤
- ❌ 과도한 장식
- ❌ 강한 블루/바이올렛/AI 색상

---

## 1️⃣ 디자인 토큰 (Design Tokens)

### 기본 색상 시스템

```dart
// 배경
AppColors.background      // #FFFFFF (White - 화면 배경)
AppColors.surface         // #FFFFFF
AppColors.surfaceWarm     // #FEF9F3 (연한 베이지-크림, 카드 기본)

// 텍스트
AppColors.textPrimary     // #1F2937 (Warm Dark Gray)
AppColors.textSecondary   // #64748B (Muted Gray)

// 경계선
AppColors.line            // #E5E7EB (Gray 200, 부드러운 구분선)
AppColors.borderSoft      // #E5E7EB (별칭)

// 버튼 / 액션
AppColors.primary         // #14B8A6 (Soft Teal – 결정/이동)
AppColors.primaryDark     // #0F766E (호버/활성)
AppColors.primaryCoral    // #E07A5F (Warm Terracotta – 주요 CTA 버튼)

// 상태 / 안심
AppColors.petGreen        // #10B981 (Warm Emerald – 안심 신호)
AppColors.petGreenLight   // #ECFDF5 (opacity 배경용)

// Accent / 포인트 (제한적 사용)
AppColors.accentWarm      // #F4A261 (Gentle Warm Orange, 혜택·최저가 알림에만)

// 상태 색상
AppColors.positive        // #10B981 (안심 그린)
AppColors.caution         // #F4A261 (주의 오렌지)
AppColors.danger          // #C2410C (따뜻한 레드, 과하지 않게)
```

### 컬러 사용 규칙

#### 배경
- **화면 배경** → White (#FFFFFF)
- **카드 배경** → surfaceWarm (#FEF9F3) - 따뜻한 크림

#### 헤더/탑바
- **헤더/탑바 배경** → White (#FFFFFF)
- **헤더 텍스트/아이콘** → textPrimary (#1F2937)

#### 주요 CTA 버튼
- **"지금 추천받기", "등록하기", "구매하기"** → primaryCoral (#E07A5F) 또는 primary (#14B8A6)
- Warm 컬러는 버튼과 이벤트에만 사용

#### 안심 신호
- **현재 급여 중** → petGreen (#10B981) + opacity 0.08~0.12 배경

#### 강조 텍스트 / 링크
- **강조 텍스트 / 링크** → primaryCoral 또는 primary

#### 금지 사항
- ❌ 네온 색상
- ❌ 강한 블루/바이올렛
- ❌ AI 색상 (쌤대신 스타일)
- ❌ 과도한 그라데이션

---

## 2️⃣ 타이포그래피

### 폰트 패밀리

```dart
fontFamily: 'system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", sans-serif',
```

### 폰트 크기 & 스타일

```dart
// H1: 42px (모바일 34px), fontWeight: 900, letterSpacing: -1px
AppTypography.h1
AppTypography.h1Mobile

// H2: 26px, fontWeight: 900, letterSpacing: -0.5px
AppTypography.h2

// H3: 18px, fontWeight: 900, letterSpacing: -0.2px
AppTypography.h3

// Body: 16px, fontWeight: 400, lineHeight: 1.6
AppTypography.body

// Body2 / Small: 14px, fontWeight: 400
AppTypography.small

// Button: 16px, fontWeight: 800
AppTypography.button

// Badge/Chip: 13px, fontWeight: 700~800
AppTypography.caption
AppTypography.badge
```

### Line Height

- 본문: **1.6**
- 약관/상세 텍스트: **1.75**

---

## 3️⃣ 간격 시스템

### 기본 간격

```dart
class AppSpacing {
  static const double xs = 4;     // micro (호환성)
  static const double sm = 8;     // element gap (icon-text, label-value)
  static const double md = 12;    // group gap (section 내부)
  static const double lg = 16;    // 카드 내부 기본
  static const double xl = 24;    // 섹션·카드 간
  static const double xxl = 32;   // 큰 여백
  static const double xxxl = 48;  // 큰 여백 (히어로·섹션 분리)
}
```

### 패딩 & 마진 패턴 (쌤대신 패턴)

- **페이지 Wrap Padding**: `EdgeInsets.fromLTRB(18, 28, 18, 80)`
- **카드 내부 Padding**: `24px` (xl)
- **버튼 Padding**: `12px vertical, 16~24px horizontal`
- **섹션 Margin Top**: `32px` (xxl)
- **Grid Gap**: `14~16px`
- **Button Row Gap**: `10~12px`
- **Chip Gap**: `8px` (sm)

### 사용 원칙

- 카드 padding: `xl` (24px)
- 카드 간격: `xl` (24px)
- 섹션 간격: `xxl` ~ `xxxl` (32px ~ 48px)
- ❌ 하드코딩 금지

---

## 4️⃣ AppRadius 가이드

```dart
class AppRadius {
  static const double sm = 8;     // 칩·배지
  static const double md = 12;    // 기본 카드·버튼 (헤이제노 기본)
  static const double lg = 16;    // 큰 카드·바텀시트
  static const double pill = 999; // 완전 둥근 CTA
}
```

### 사용 원칙

- 칩/배지: `sm` (8px)
- 카드/버튼: `md` (12px)
- 큰 카드/바텀시트: `lg` (16px)
- 완전 둥근 버튼: `pill` (999)

---

## 5️⃣ 그림자 & 효과 (헤이제노 버전)

### 기본 원칙

**Shadow 거의 사용 안 함 (The Farmer's Dog 스타일)**

- 기본: Shadow ❌
- 구분: Border 1px (#E5E7EB) 또는 배경 대비로

### 허용 예외 (아주 제한적)

- **BottomSheet**: `blurRadius: 12, opacity: 0.06`
- **Floating CTA**: 아주 미세한 shadow (opacity 0.05 이하)

### Border 사용

- 얇은 회색 border로 구분
- 색상: `#E5E7EB` 또는 `AppColors.line`
- 두께: 1px

### 금지 사항

- ❌ 쌤대신의 강한 shadow (0 10px 30px 0.08 등) 완전히 제거

---

## 6️⃣ CardContainer & 기본 컨테이너 규칙

### CardContainer 기본 스타일

```dart
CardContainer(
  padding: EdgeInsets.all(AppSpacing.xl), // 24px 넉넉하게
  borderRadius: BorderRadius.circular(AppRadius.md), // 12px
  backgroundColor: AppColors.surfaceWarm, // 따뜻한 크림
  border: Border.all(color: AppColors.line, width: 1), // 아주 얇은 회색
  child: ...
)
```

### 카드 디자인 원칙

- 카드마다 역할 명확
- 장식 최소화
- 타이틀은 항상 명확하게
- 넉넉한 padding으로 편안함 제공
- Shadow 없음, Border로 구분

---

## 7️⃣ 컴포넌트 스타일

### TopBar / Header

```dart
// 배경: White (#FFFFFF)
// 텍스트/아이콘: textPrimary (#1F2937)
// Border: bottom 1px line (#E5E7EB)
AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  titleTextStyle: TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
  iconTheme: IconThemeData(
    color: AppColors.textPrimary,
  ),
)
```

### Button

#### Primary Button

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryCoral, // Warm Terracotta 또는 primary (Soft Teal)
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md), // 12px
    ),
    elevation: 0, // Shadow 없음
  ),
  child: Text('지금 추천받기'),
  onPressed: () {},
)
```

#### Subtle Button

```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    side: BorderSide(color: AppColors.line, width: 1),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md), // 12px
    ),
  ),
  child: Text('더 보기'),
  onPressed: () {},
)
```

### Chip/Badge

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: AppColors.petGreen, // 또는 배경색
    borderRadius: BorderRadius.circular(AppRadius.pill), // 999
  ),
  child: Text(
    '현재 급여 중',
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
)
```

### Callout / Warm Line

```dart
Container(
  padding: EdgeInsets.all(AppSpacing.lg),
  decoration: BoxDecoration(
    color: AppColors.surfaceWarm,
    borderRadius: BorderRadius.circular(AppRadius.lg), // 16px
    border: Border.all(color: AppColors.line, width: 1),
  ),
  child: ...
)
```

### Grid / Flex Row

- **Gap**: `14~16px`
- **Button Row Gap**: `10~12px`
- **Chip Gap**: `8px`

---

## 8️⃣ 홈 화면 전용 UI 원칙

The Farmer's Dog처럼 **"집 같은 편안함"** 중심

### 우선순위

1. **펫 프로필 헤더** (사진 크게, warm 배경)
2. **현재 급여 사료 카드** (메인, petGreen 포인트)
3. **상태 신호 카드** (안심 중심)
4. **추천 카드** (조건부, coral CTA)
5. **혜택 하단** (gentle warm accent)

### 색 흐름

White 배경  
→ White TopBar  
→ Warm Cream 카드  
→ Muted Olive Green 상태  
→ Warm Coral CTA  
→ Gentle Orange 혜택 포인트

---

## 9️⃣ 반응형 디자인

### 브레이크포인트

- **모바일**: `max-width: 520px`
- **태블릿**: `max-width: 900px`

### 반응형 규칙

- **그리드** → 모바일 1열로 collapse
- **폰트** → 모바일 축소 (h1: 42px → 34px 등)
- **패딩** → 모바일 축소

---

## 🔟 애니메이션 & 트랜지션

### Duration

- 기본: **300~500ms**
- 짧은 트랜지션: **150~200ms**

### Curve

- **Curves.easeOut** (자연스럽고 부드럽게)
- **Curves.easeOutQuad** (헤이제노 기본)

### 트랜지션 패턴 (쌤대신 패턴 유지)

```dart
// transition: transform 0.06s ease, background 0.12s ease
AnimatedContainer(
  duration: Duration(milliseconds: 120),
  curve: Curves.ease,
  transform: Matrix4.translationValues(0, -1, 0), // hover: translateY(-1px) 살짝
  child: ...
)
```

### 금지 사항

- ❌ 과도한 효과
- ❌ 강한 bounce
- ❌ 긴 duration (500ms 초과)

---

## ✅ 최종 체크리스트

- [ ] 화면 배경이 White인가?
- [ ] TopBar가 White 배경인가?
- [ ] 주요 CTA가 Warm Coral / Terracotta 또는 Soft Teal인가?
- [ ] Warm 컬러가 버튼/이벤트에만 사용되는가?
- [ ] 강한 그림자 / 네온 색상 없나?
- [ ] 전체가 "집 안 거실처럼 편안한가"?
- [ ] 여백이 넉넉하고 숨 쉴 수 있는가?
- [ ] 카드가 surfaceWarm 배경과 border로 구분되는가?

---

## 📚 참고 파일

- `frontend/lib/app/theme/app_colors.dart` - 색상 정의
- `frontend/lib/app/theme/app_typography.dart` - 타이포그래피 정의
- `frontend/lib/app/theme/app_spacing.dart` - 간격 정의
- `frontend/lib/app/theme/app_radius.dart` - 반경 정의
- `frontend/lib/ui/widgets/app_top_bar.dart` - 상단 바 컴포넌트
- `frontend/lib/ui/widgets/card_container.dart` - 카드 컴포넌트

---

**버전**: v2.2 (쌤대신 구조 + 헤이제노 감성 통합)  
**마지막 업데이트**: 2026년

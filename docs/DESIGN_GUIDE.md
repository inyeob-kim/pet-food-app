# 🎨 헤이제노 디자인 시스템 v4.1
## Data-Driven Premium Platform Edition

> 데이터 기반 펫 케어 & 멀티플랫폼 최저가 알림 서비스  
> 키워드: **Trust · Precision · Clarity · Premium Neutral**

---

## 📋 목차

0. 브랜드 정의  
1. 컬러 전략  
2. 버튼 시스템  
3. 타이포그래피  
4. 간격 시스템  
5. AppRadius 가이드  
6. 카드 디자인  
7. 가격 데이터 표현 원칙  
8. 탭 디자인  
9. 홈 화면 구조  
10. 그림자 & 효과  
11. 애니메이션 & 트랜지션  
12. 반응형 디자인  
13. 최종 체크리스트  

---

## 0️⃣ 브랜드 정의

### 핵심 포지션

**헤이제노는 감성 펫앱이 아니다.**  
**데이터 기반 의사결정 플랫폼이다.**

### 브랜드 포지션

- **비교** - 멀티플랫폼 가격 비교
- **추적** - 가격 히스토리 추적
- **분석** - 데이터 기반 인사이트
- **알림** - 최저가 알림 서비스
- **멀티 플랫폼** - 통합 가격 데이터

### 디자인 철학

- **Trust** - 신뢰할 수 있는 데이터
- **Precision** - 정확한 정보 전달
- **Clarity** - 명확한 구조와 계층
- **Premium Neutral** - 프리미엄 중립 톤

### 시각 원칙

- 데이터 우선, 장식 최소화
- 구조가 장식보다 우선
- 수치와 그래프 명확히 표현
- 프리미엄 플랫폼 느낌
- Admin과 자연스러운 통합

---

## 1️⃣ 컬러 전략

### 🎯 컬러 철학

> **Blue = 브랜드 & 결정**  
> **Green = 상태 & 정상**  
> **Red = 가격 상승/위험**  
> **Neutral = 데이터 기반 구조**

### 🔵 Brand Primary (Core Identity)

```dart
AppColors.primary        // #1D4ED8 (Deep Data Blue)
AppColors.primaryHover   // #1E40AF
AppColors.primaryLight   // #E6ECFA
```

**의미**: 신뢰 · 플랫폼 · 구조 · 분석 · 가격 결정

**사용 위치**:
- Primary CTA 버튼
- 탭 활성 상태
- 선택된 필터
- 강조 수치
- 링크

### 🟢 Status Color

```dart
AppColors.status         // #16A34A
AppColors.statusLight    // #ECFDF5
```

**사용 위치**:
- 현재 급여 중
- 알림 ON
- 정상 상태
- 가격 하락 성공

**❌ 버튼 사용 금지**  
**❌ 브랜드 대체 금지**

### 🔴 Alert / Drop

```dart
AppColors.drop           // #DC2626
AppColors.dropLight      // #FEE2E2
```

**사용 위치**:
- 가격 상승/위험 알림 전용

### ⚪ Premium Neutral

```dart
AppColors.background     // #F8F8F6 (완전 화이트 아님)
AppColors.surface        // #FFFFFF
AppColors.textPrimary    // #0F172A
AppColors.textSecondary  // #6B7280
AppColors.border         // #E5E7EB
AppColors.divider        // #F1F5F9
```

### 컬러 사용 규칙

#### 배경
- **화면 배경** → Premium Neutral (#F8F8F6)
- **카드 배경** → White (#FFFFFF)

#### 헤더/탑바
- **헤더/탑바 배경** → White (#FFFFFF)
- **헤더 텍스트/아이콘** → textPrimary (#0F172A)

#### 주요 CTA 버튼
- **"가격 비교하기", "최저가 확인", "알림 설정", "등록하기"** → primary (#1D4ED8)
- 모든 주요 버튼은 Blue 계열로 통일

#### 탭 / 필터
- **활성 탭** → primary (#1D4ED8) + primaryLight 배경 (#E6ECFA)
- **비활성 탭** → textSecondary (#6B7280)

#### 상태 표시
- **정상/급여 중** → status (#16A34A)
- **가격 하락** → status (#16A34A)
- **가격 상승** → drop (#DC2626)

#### 금지 사항
- ❌ Green을 Primary CTA 버튼에 사용
- ❌ Red를 상태 표시에 사용 (가격 상승 전용)
- ❌ 완전 화이트 배경 (#FFFFFF) - Premium Neutral 사용
- ❌ 과도한 색상 혼용 (데이터 카드에서 2개 이상 색상 사용 금지)

---

## 2️⃣ 버튼 시스템

### Primary Button

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary, // #1D4ED8
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md), // 12px
    ),
    elevation: 0,
  ),
  child: Text('가격 비교하기'),
  onPressed: () {},
)
```

**사용 예**:
- 가격 비교하기
- 최저가 확인
- 알림 설정
- 등록하기

### Secondary Button

```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary, // #0F172A
    side: BorderSide(color: AppColors.border, width: 1), // #E5E7EB
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md), // 12px
    ),
  ),
  child: Text('더 보기'),
  onPressed: () {},
)
```

### Text Button

```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.primary, // #1D4ED8
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  child: Text('링크 텍스트'),
  onPressed: () {},
)
```

---

## 3️⃣ 타이포그래피

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

// Data / Number: 20px, fontWeight: 900 (수치 강조용)
AppTypography.data
```

### Line Height

- 본문: **1.6**
- 약관/상세 텍스트: **1.75**

### 데이터 표현 원칙

- **수치는 bold (fontWeight: 900)**
- **그래프는 미니멀**
- **색은 2개 이상 쓰지 않는다**

---

## 4️⃣ 간격 시스템

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

### 패딩 & 마진 패턴

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

## 5️⃣ AppRadius 가이드

```dart
class AppRadius {
  static const double sm = 8;     // 칩·배지
  static const double md = 12;    // 기본 카드·버튼
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

## 6️⃣ 카드 디자인

### 기본 카드

```dart
CardContainer(
  padding: EdgeInsets.all(AppSpacing.xl), // 24px
  borderRadius: BorderRadius.circular(AppRadius.md), // 12px
  backgroundColor: AppColors.surface, // White (#FFFFFF)
  border: Border.all(color: AppColors.border, width: 1), // #E5E7EB
  shadow: BoxShadow(
    color: Colors.black.withOpacity(0.03),
    blurRadius: 6,
    offset: Offset(0, 2),
  ),
  child: ...
)
```

### 데이터 카드 원칙

- **수치 강조** (bold, fontWeight: 900)
- **그래프는 미니멀**
- **색은 2개 이상 쓰지 않는다**
- **장식보다 구조 우선**

### 카드 디자인 원칙

- 카드마다 역할 명확
- 타이틀은 항상 명확하게
- 넉넉한 padding으로 편안함 제공
- 미세한 shadow로 깊이감 제공 (opacity: 0.03)

---

## 7️⃣ 가격 데이터 표현 원칙

### 가격 하락

- **수치**: Primary Blue (#1D4ED8)
- **보조 표시**: Green (#16A34A)
- **배경**: statusLight (#ECFDF5) - 선택적

### 가격 상승

- **수치**: Red (#DC2626)
- **배경**: dropLight (#FEE2E2) - tint 사용

### 가격 히스토리 차트

- **차트 색상**: Primary Blue (#1D4ED8)
- **하락 구간**: Green (#16A34A)
- **상승 구간**: Red (#DC2626)
- **미니멀 디자인**: 선만 사용, 배경 최소화

---

## 8️⃣ 탭 디자인

### 활성 탭

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: AppColors.primaryLight, // #E6ECFA
    borderRadius: BorderRadius.circular(AppRadius.sm), // 8px
  ),
  child: Text(
    '탭 이름',
    style: TextStyle(
      color: AppColors.primary, // #1D4ED8
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  ),
)
```

### 비활성 탭

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Text(
    '탭 이름',
    style: TextStyle(
      color: AppColors.textSecondary, // #6B7280
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
)
```

---

## 9️⃣ 홈 화면 구조

### 우선순위

1. **펫 프로필** (사진, 기본 정보)
2. **현재 급여 사료** (메인 정보)
3. **최저가 상태 카드** (가격 비교 결과)
4. **가격 히스토리 미니 차트** (데이터 시각화)
5. **알림 설정** (CTA)
6. **추천** (조건부)

### 색 흐름

Premium Neutral 배경 (#F8F8F6)  
→ White TopBar  
→ White 카드  
→ Primary Blue CTA 버튼  
→ Status Green 상태 표시  
→ Drop Red 가격 상승 알림

---

## 🔟 그림자 & 효과

### 기본 원칙

**미세한 Shadow 사용 (Premium 느낌)**

- 기본 카드: `0 2px 6px rgba(0,0,0,0.03)`
- 구분: Border 1px (#E5E7EB) + 미세한 shadow

### 허용 예외

- **BottomSheet**: `blurRadius: 12, opacity: 0.06`
- **Floating CTA**: 미세한 shadow (opacity 0.03~0.05)

### Border 사용

- 얇은 회색 border로 구분
- 색상: `#E5E7EB` 또는 `AppColors.border`
- 두께: 1px

---

## 1️⃣1️⃣ 애니메이션 & 트랜지션

### Duration

- 기본: **200~350ms**
- 짧은 트랜지션: **150~200ms**

### Curve

- **Curves.easeOut** (자연스럽고 부드럽게)

### 트랜지션 패턴

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 250),
  curve: Curves.easeOut,
  child: ...
)
```

### 금지 사항

- ❌ 과도한 효과
- ❌ **bounce 금지**
- ❌ 긴 duration (350ms 초과)

---

## 1️⃣2️⃣ 반응형 디자인

### 브레이크포인트

- **모바일**: `max-width: 520px`
- **태블릿**: `max-width: 900px`

### 반응형 규칙

- **그리드** → 모바일 1열로 collapse
- **폰트** → 모바일 축소 (h1: 42px → 34px 등)
- **패딩** → 모바일 축소
- **차트** → 모바일에서 간소화

---

## ✅ 최종 체크리스트

- [ ] CTA가 Blue (#1D4ED8)인가?
- [ ] Green이 상태 전용인가? (버튼 사용 안 함)
- [ ] Red는 가격 상승 전용인가?
- [ ] 배경이 Premium Neutral (#F8F8F6)인가? (완전 화이트 아님)
- [ ] 데이터가 명확히 보이는가?
- [ ] 수치가 bold로 강조되었는가?
- [ ] 그래프가 미니멀한가?
- [ ] 데이터 카드에서 색상이 2개 이상 사용되지 않았는가?
- [ ] 장식보다 구조가 우선인가?
- [ ] 프리미엄 플랫폼 느낌이 나는가?

---

## 📚 참고 파일

- `frontend/lib/app/theme/app_colors.dart` - 색상 정의
- `frontend/lib/app/theme/app_typography.dart` - 타이포그래피 정의
- `frontend/lib/app/theme/app_spacing.dart` - 간격 정의
- `frontend/lib/app/theme/app_radius.dart` - 반경 정의
- `frontend/lib/ui/widgets/app_top_bar.dart` - 상단 바 컴포넌트
- `frontend/lib/ui/widgets/card_container.dart` - 카드 컴포넌트

---

## 🔥 이 디자인의 장점

- ✅ 헬스앱 느낌 제거
- ✅ 프리미엄 플랫폼 느낌
- ✅ Admin과 자연스럽게 통합
- ✅ 가격/데이터 서비스에 매우 적합
- ✅ 확장성 매우 높음

---

**버전**: v4.1 (Data-Driven Premium Platform Edition)  
**마지막 업데이트**: 2026년

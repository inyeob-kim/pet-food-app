# 🎨 헤이제노 디자인 시스템 가이드 v2.1

> The Farmer's Dog Color & Tone Inspired  
> 따뜻하고 신뢰감 있는 일상 펫 웰니스 앱을 위한 디자인 시스템  
> **목표**: "우리 아이를 가족처럼 챙기는" 느낌 그대로

---

## 📋 목차

0. 헤이제노 디자인 철학 (The Farmer's Dog 감성 적용)  
1. 헤이제노 전용 컬러 시스템 (The Farmer's Dog 거의 그대로)  
2. 이모지 사용 규칙  
3. 간격 시스템 (AppSpacing)  
4. AppRadius 가이드  
5. AppElevation & Border 가이드  
6. CardContainer 규칙  
7. 홈 화면 전용 UI 원칙  
8. 애니메이션 원칙  
9. 컴포넌트 가이드  
10. 최종 체크리스트  

---

## 0️⃣ 헤이제노 디자인 철학 (The Farmer's Dog 감성 적용)

### 앱의 본질

**"우리 아이의 매일을 건강하고 행복하게 지켜주는 조용한 동반자"**

### 가장 중요한 감정

- **안심(Reassurance)** + **따뜻함(Warmth)**

### 시각적 목표

- 집 안 거실처럼 편안한 공간
- 과하지 않은 자연스러움

### 금지 사항

- ❌ 화려한 효과
- ❌ 강한 대비
- ❌ 차가운 톤
- ❌ 과도한 장식

### 핵심 원칙

- **Warm neutrals가 주인공**
- 자연에서 온 듯한 깊은 그린 + muted 따뜻한 코랄
- 넉넉한 여백과 숨 쉴 수 있는 레이아웃
- 전문적이면서도 가족 같은 친밀함

---

## 1️⃣ 헤이제노 전용 컬러 시스템 (The Farmer's Dog 거의 그대로)

### 주요 색상 (직접 추출·매핑)

```dart
// 배경 – The Farmer's Dog 전체 베이스 톤
AppColors.background      // #FDFAF5 ~ #FEFCFA  (Warm Cream / Off-White)

// 카드 / Surface – 살짝 더 밝은 크림
AppColors.surface         // #FFFFFF
AppColors.surfaceWarm     // #FEF9F3  (연한 베이지-크림, 카드 배경 추천)

// 텍스트
AppColors.textPrimary     // #1F2A2F  (따뜻한 다크 차콜)
AppColors.textSecondary   // #5C6B74  (muted gray-green)

// 헤더 / 네비게이션 – The Farmer's Dog 상단 그린
AppColors.headerGreen     // #1A3C34 ~ #0F2E26  (Deep Forest Green)

// Primary CTA / 결정 버튼 – The Farmer's Dog 주요 버튼 색상
AppColors.primaryCoral    // #E07A5F ~ #D65A3F  (Warm Terracotta / Muted Coral)

// 상태 / 안심 신호 – The Farmer's Dog가 주는 "건강함" 느낌에 가까운 그린
AppColors.petGreen        // #3A7D5E ~ #4A8F6E  (Muted Olive Green)

// Accent / 포인트 (제한적 사용)
AppColors.accentWarm      // #F4A261  (Gentle Warm Orange, 혜택·최저가 알림에만)

// 상태 색상
AppColors.positive        // #4A8F6E  (안심 그린)
AppColors.caution         // #F4A261  (주의 오렌지)
AppColors.danger          // #C2410C  (따뜻한 레드, 과하지 않게)
```

### 컬러 사용 규칙 (The Farmer's Dog 스타일 적용)

#### 배경
- **전체 배경** → 항상 Warm Cream (#FDFAF5 계열) 사용

#### 헤더/탑바
- **헤더/탑바** → Deep Forest Green (#1A3C34)

#### 주요 CTA 버튼
- **"지금 추천받기", "등록하기", "구매하기"** → Warm Terracotta (#E07A5F)

#### 안심 신호
- **현재 급여 중** → Muted Olive Green (#4A8F6E) + opacity 0.08~0.12 배경

#### 강조 텍스트 / 링크
- **강조 텍스트 / 링크** → primaryCoral 또는 headerGreen

#### 금지 사항
- ❌ 네온 색상
- ❌ 강한 블루
- ❌ 바이올렛
- ❌ 과도한 그라데이션

---

## 2️⃣ 이모지 사용 규칙

### 핵심 원칙

**섹션당 최대 1개, 중심에 배치**

### 허용 위치

- 섹션 타이틀
- 카드 헤더
- 상태 요약

### 금지 위치

- 본문 중간
- 버튼
- 반복 사용

### 기본 세트

| 용도 | 이모지 |
|------|--------|
| 펫 | 🐶 🐱 |
| 사료 | 🥣 |
| 가격 | 📉 |
| 시간 | ⏰ |
| 혜택 | 🎁 |
| 완료 | ✅ |
| 주의 | ⚠️ |

---

## 3️⃣ 간격 시스템 (AppSpacing)

The Farmer's Dog처럼 넉넉하게 유지

```dart
class AppSpacing {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;   // 카드 내부 기본 (더 넓게)
  static const double xl = 32;
  static const double xxl = 48;  // 섹션 간 큰 여백
}
```

### 사용 원칙

- 카드 padding: `lg` (24px)
- 카드 간격: `lg` (24px)
- 섹션 간격: `xl` ~ `xxl` (32px ~ 48px)
- ❌ 하드코딩 금지

---

## 4️⃣ AppRadius 가이드

The Farmer's Dog처럼 부드럽지만 과하지 않게

```dart
class AppRadius {
  static const double sm = 8;    // 칩·배지
  static const double md = 16;   // 카드·버튼 기본 (The Farmer's Dog 느낌)
  static const double lg = 24;   // 큰 카드·바텀시트
}
```

### 사용 원칙

- 칩/배지: `sm` (8px)
- 카드/버튼: `md` (16px)
- 큰 카드/바텀시트: `lg` (24px)

---

## 5️⃣ AppElevation & Border 가이드

### Shadow 거의 사용 안 함 (The Farmer's Dog 스타일)

**원칙**
- 기본: Shadow ❌
- 구분: 얇은 border 또는 배경 대비로

### 허용 shadow (예외적 사용)

- blur: 12px
- opacity: 0.04
- offset: 0, 4px

### Border 사용

- 얇은 회색 border로 구분
- 색상: `#E5E7EB` 또는 `AppColors.borderSoft`
- 두께: 1px

---

## 6️⃣ CardContainer 규칙

```dart
CardContainer(
  padding: EdgeInsets.all(AppSpacing.lg),  // 24px 넉넉하게
  borderRadius: BorderRadius.circular(AppRadius.md),  // 16px
  backgroundColor: AppColors.surfaceWarm,  // 따뜻한 크림
  border: Border.all(color: Color(0xFFE5E7EB), width: 1),  // 아주 얇은 회색
  child: ...
)
```

### 카드 디자인 원칙

- 카드마다 역할 명확
- 장식 최소화
- 타이틀은 항상 명확하게
- 넉넉한 padding으로 편안함 제공

---

## 7️⃣ 홈 화면 전용 UI 원칙

The Farmer's Dog처럼 **"집 같은 편안함"** 중심

### 우선순위

1. **펫 사진 + 이름 헤더** (큰 사진, 따뜻한 배경)
2. **현재 급여 사료 카드** (메인, petGreen accent)
3. **건강 상태 한눈에** (안심 신호 중심)
4. **추천 섹션** (조건부, coral CTA 버튼)
5. **혜택·알림** (하단, gentle warm accent)

### 색 흐름

Warm Cream 배경  
→ Deep Forest Green 헤더  
→ Warm Cream 카드  
→ Muted Olive Green 상태  
→ Warm Coral CTA  
→ Gentle Orange 혜택 포인트

---

## 8️⃣ 애니메이션 원칙

### Duration

- 기본: **350~500ms**

### Curve

- **Curves.easeOutQuad** (자연스럽고 부드럽게)

### 금지 사항

- ❌ 과도한 효과
- ❌ 강한 bounce
- ❌ 긴 duration (500ms 초과)

---

## 9️⃣ 컴포넌트 가이드 (주요 예시)

### TopBar / Header

```dart
// 배경: headerGreen (#1A3C34)
// 로고/타이틀: 흰색
// CTA 버튼: coral (#E07A5F)
```

### 추천 받기 버튼

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryCoral,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  child: Text('지금 추천받기'),
  onPressed: () {},
)
```

### 현재 급여 사료 카드

```dart
CardContainer(
  padding: EdgeInsets.all(AppSpacing.lg),
  borderRadius: BorderRadius.circular(AppRadius.md),
  backgroundColor: AppColors.surfaceWarm,
  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
  child: Column(
    children: [
      // 상태 뱃지: petGreen 배경 + 흰 글씨 "현재 급여 중"
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.petGreen,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          '현재 급여 중',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // 카드 내용...
    ],
  ),
)
```

---

## ✅ 최종 체크리스트

- [ ] 배경이 Warm Cream / Off-White인가?
- [ ] 헤더가 Deep Forest Green인가?
- [ ] 주요 CTA가 Warm Coral / Terracotta인가?
- [ ] 강한 그림자 / 네온 색상 없나?
- [ ] 전체가 "집 안 거실처럼 편안한가"?
- [ ] 여백이 넉넉하고 숨 쉴 수 있는가?

---

## 📚 참고 파일

- `frontend/lib/app/theme/app_colors.dart` - 색상 정의
- `frontend/lib/app/theme/app_typography.dart` - 타이포그래피 정의
- `frontend/lib/app/theme/app_spacing.dart` - 간격 정의
- `frontend/lib/app/theme/app_radius.dart` - 반경 정의
- `frontend/lib/ui/widgets/top_bar.dart` - 상단 바 컴포넌트
- `frontend/lib/ui/widgets/card_container.dart` - 카드 컴포넌트

---

**버전**: v2.1 (The Farmer's Dog Color & Tone Inspired)  
**마지막 업데이트**: 2026년

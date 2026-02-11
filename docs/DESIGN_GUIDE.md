# 🎨 헤이제노 디자인 시스템 가이드 v1.1 (Tone Refined, 2026)

> 일상 관리형 펫 서비스에 최적화된 디자인 시스템  
> **Tone Reference**: Warm Cream + Calm Blue + Soft Natural Accent  
> **목표**: 안심 · 신뢰 · 따뜻한 돌봄 브랜드

---

## 📋 목차

0. 헤이제노 디자인 철학  
1. 헤이제노 전용 컬러 시스템  
2. 이모지 사용 규칙  
3. 간격 시스템 (AppSpacing)  
4. AppRadius 가이드  
5. AppElevation 가이드  
6. CardContainer 규칙  
7. 홈 화면 전용 UI 원칙  
8. 애니메이션 원칙  
9. 컴포넌트 가이드  
10. 타이포그래피  
11. 최종 체크리스트  

---

## 0️⃣ 헤이제노 디자인 철학

### 헤이제노는 이런 앱이다

❌ 매번 무언가를 추천하는 앱  
✅ **지금 상태를 한눈에 보고 안심하는 앱**

### 핵심 키워드

- **Manage**: 현재 상태 관리
- **Reassurance**: 잘하고 있다는 신호
- **Daily**: 매일 사용하는 도구
- **Care-first Brand**: 돌봄 중심 브랜드
- **Comfort & Calm Confidence (2026)**

### 디자인 원칙

- 차분하지만 차갑지 않게  
- 귀엽지만 유치하지 않게  
- 색으로 감정을 자극하지 말고 **안심을 전달**

---

## 1️⃣ 헤이제노 전용 컬러 시스템

### 🎯 컬러 사용의 대원칙

> **색은 감정이 아니라 역할이다**

---

### 🌈 컬러 팔레트 (최종)

```dart
// Background
AppColors.background        // #FDF8F3  (Warm Cream)
AppColors.surface           // #FFFFFF
AppColors.surfaceWarm       // #FFFDF9

// Brand / Navigation
AppColors.primaryBlue       // #1E4ED8  (Calm Blue)
AppColors.primaryBlueSoft   // #E8EEFB  (Tint)

// Sub Primary
AppColors.primaryTeal       // #2BB0ED  (보조 CTA)

// Status / Pet
AppColors.petGreen          // #22C58B
AppColors.petGreenLight     // #EAF7F1

// Accent
AppColors.softYellow        // #F4C430  (장식 전용)

// Text
AppColors.textPrimary       // #0F172A
AppColors.textSecondary     // #64748B

// Border
AppColors.borderSoft        // #E5E7EB
```

### 🔵 Primary Blue 사용 규칙

**역할**: 브랜드 / 결정 / 이동

**사용 위치**
- TopBar
- 메인 CTA (화면당 1개)
- 탭 활성 상태
- 링크 / 강조 텍스트

**금지**
- 상태 표시
- 성공/안심 메시지
- 반복 버튼

### 🟢 Pet Green 사용 규칙

**역할**: 안심 / 정상 / 현재 상태

- 상태 배지
- "현재 급여 중"
- 가격 알림 ON
- 배경 사용 시 opacity 0.08~0.12만 허용

### 🟡 Soft Yellow 사용 규칙

⚠️ **절대 주연 금지**

**허용**
- 히어로 영역 장식
- 카드 내부 포인트
- 아이콘 배경 원

**금지**
- 버튼
- 텍스트
- 상태 표현

---

## 2️⃣ 이모지 사용 규칙

### 핵심 원칙

**이모지는 정보 보조 도구다**

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

```dart
class AppSpacing {
  static const xs = 4;
  static const sm = 8;
  static const md = 12;
  static const lg = 16;
  static const xl = 24;
}
```

### 원칙

- 카드 padding: `lg`
- 카드 간: `lg`
- 섹션 간: `xl`
- ❌ 하드코딩 금지

---

## 4️⃣ AppRadius 가이드

```dart
class AppRadius {
  static const sm = 8;
  static const md = 12;
  static const lg = 16;
  static const xl = 20;
}
```

- 카드 / 버튼: `md`
- 배지: `sm`
- 바텀시트: `lg~xl`

---

## 5️⃣ AppElevation 가이드

### 원칙

**헤이제노는 그림자를 거의 쓰지 않는다**

- 기본: Shadow ❌
- 구분: Border + 색온도

### 예외

- BottomSheet
- Floating CTA

---

## 6️⃣ CardContainer 규칙

```dart
CardContainer(
  padding: AppSpacing.lg,
  borderRadius: AppRadius.md,
  backgroundColor: AppColors.surfaceWarm,
  borderColor: AppColors.borderSoft,
)
```

### 카드 디자인 원칙

- 카드마다 역할 명확
- 장식 최소화
- 타이틀은 항상 h3

---

## 7️⃣ 홈 화면 전용 UI 원칙

### 홈은 추천 화면이 아니다

**우선순위**
1. 현재 급여 사료
2. 가격 / 소진 상태
3. 조건부 추천
4. 혜택 (보조)

### 색 흐름

Warm Cream 배경  
→ Blue 브랜드 포인트  
→ Warm White 카드  
→ Green 상태  
→ Yellow 감성 장식

---

## 8️⃣ 애니메이션 원칙

### Duration

- 짧음: 300ms
- 기본: 400ms
- 길게: 500ms

### Curve

- 진입: `easeOut`
- 완료: `easeOutBack` (절제)

❌ 과한 Bounce 금지

---

## 9️⃣ 컴포넌트 가이드

### TopBar

- 높이 56px
- 배경: `surfaceWarm`
- 활성 요소: `primaryBlue`

### 버튼

#### Primary Button

```dart
CupertinoButton(
  color: AppColors.primaryBlue,
)
```

#### Outlined Button

```dart
OutlinedButton(
  side: BorderSide(color: AppColors.primaryBlue),
)
```

---

## 🔟 타이포그래피

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| h1 | 42 / 34 | 900 | 히어로 |
| h2 | 26 | 900 | 섹션 |
| h3 | 18 | 900 | 카드 |
| body | 16 | 400 | 본문 |
| small | 14 | 400 | 보조 |
| caption | 13 | 700 | 배지 |
| button | 16 | 800 | 버튼 |

Yellow 텍스트 사용 금지

---

## ✅ 최종 체크리스트

- [ ] 배경이 Warm Cream인가
- [ ] Blue는 결정/브랜드 전용인가
- [ ] Green은 상태 전용인가
- [ ] Yellow는 장식으로만 쓰였는가
- [ ] Shadow 대신 Border를 썼는가
- [ ] 홈에서 추천이 과하지 않은가
- [ ] iOS 스타일을 유지했는가

---

## 📚 참고 파일

- `frontend/lib/app/theme/app_colors.dart` - 색상 정의
- `frontend/lib/app/theme/app_typography.dart` - 타이포그래피 정의
- `frontend/lib/app/theme/app_spacing.dart` - 간격 정의
- `frontend/lib/app/theme/app_radius.dart` - 반경 정의
- `frontend/lib/ui/widgets/top_bar.dart` - 상단 바 컴포넌트
- `frontend/lib/ui/widgets/card_container.dart` - 카드 컴포넌트

---

**버전**: v1.1 (Tone Refined)  
**마지막 업데이트**: 2026년

# 🎨 HeyZeno 화면 구조 가이드 - Figma 디자인용

**각 화면별 레이아웃, 컴포넌트, 데이터 구조 상세 문서**

---

## 📋 목차

1. [공통 디자인 시스템](#1-공통-디자인-시스템)
2. [홈 화면 (Home Screen)](#2-홈-화면-home-screen)
3. [찜한 사료 화면 (Watch/Favorites Screen)](#3-찜한-사료-화면-watchfavorites-screen)
4. [사료마켓 화면 (Market Screen)](#4-사료마켓-화면-market-screen)
5. [상품 상세 화면 (Product Detail Screen)](#5-상품-상세-화면-product-detail-screen)
6. [혜택 화면 (Benefits Screen)](#6-혜택-화면-benefits-screen)
7. [마이 화면 (My/Me Screen)](#7-마이-화면-myme-screen)
8. [온보딩 화면 (Onboarding)](#8-온보딩-화면-onboarding)

---

## 1. 공통 디자인 시스템

### 색상 팔레트

| 토큰 | Hex | 용도 |
|------|-----|------|
| **Primary** | `#2563EB` | CTA 버튼, 선택 상태, 강조 |
| **Text Main** | `#111827` | 제목, 본문 텍스트 |
| **Text Sub** | `#6B7280` | 보조 텍스트, 힌트 |
| **Positive** | `#16A34A` | 성공, 건강 상태, 저렴함 |
| **Negative** | `#EF4444` | 에러, 경고, 비쌈 |
| **Background** | `#F7F8FA` | 화면 배경 |
| **Surface** | `#FFFFFF` | 카드, 입력 필드 배경 |
| **Divider** | `#E5E7EB` | 구분선 (최소 사용) |
| **Primary Soft** | `#EFF6FF` | 선택된 카드 배경 |

### 타이포그래피

| 스타일 | 크기 | 굵기 | 용도 | Letter Spacing |
|--------|------|------|------|---------------|
| **Hero** | 38px | Bold (700) | 포인트 숫자 | -0.5 |
| **Title** | 23px | SemiBold (600) | 화면 제목, 섹션 제목 | -0.4 |
| **Body** | 17px | Medium (500) | 본문, 입력값 | -0.3 |
| **Sub** | 14px | Regular (400) | 보조 텍스트, 힌트 | -0.3 |
| **Price Numeric** | 24px | Bold (700) | 가격 숫자 | -0.4 |

**폰트**: Pretendard (fallback: NotoSansKR, Apple SD Gothic Neo, Roboto)

### 레이아웃 규칙

- **화면 패딩**: 좌우 16px, 상하 16~24px
- **섹션 간격**: 24~32px
- **컴포넌트 간격**: 12~16px
- **카드/구분선 금지**: 토스 스타일 원칙
- **여백으로만 구분**: spacing으로 정보 위계 표현

### 공통 컴포넌트

#### SectionHeader
- **용도**: 섹션 제목 + 서브타이틀 + 더보기
- **패딩**: 좌우 16px, 상 8px, 하 12px
- **타이틀**: Title 스타일
- **서브타이틀**: Sub 스타일 (선택)
- **더보기**: chevron_right 아이콘 (선택)

#### MetricRow
- **용도**: 수치 요약 (예: "평균 대비 -7.9%")
- **레이아웃**: Label (왼쪽, Sub) + Value (오른쪽, Body Bold, 색상 적용)
- **Helper Text**: 아래 작게 (12px, Sub)

#### ProductTile
- **용도**: 상품 타일 (카드 느낌 없음)
- **구성**: 이미지 (1:1, radius 16) + 브랜드 (Sub, 회색) + 상품명 (Body Medium, 2줄) + 가격 (Body Bold)
- **옵션**: 할인율/상태 텍스트 (12px, 빨강/회색)

---

## 2. 홈 화면 (Home Screen)

### 화면 목적
- 반려동물 맞춤 추천 사료 표시
- "요약 → 추천 → CTA" 흐름으로 구매 판단 유도

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ AppBar                          │
│ "오늘, {petName}에게 딱 맞는 사료 🐾" │
├─────────────────────────────────┤
│                                 │
│ [PetCard]                       │
│ - 이름 · 나이 · 몸무게          │
│ - 건강 포인트 (sub 색상)        │
│ - 프로필 수정 (링크)            │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [RecommendationCard]            │
│ - 상품명 (Body)                 │
│ - 가격 (Price Numeric, Bold)    │
│ - MetricRow (평균 대비 %)       │
│ - "왜 추천?" (링크)             │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [판단 문장] (조건부)            │
│ "지금은 평균보다 저렴한 구간이에요" │
│                                 │
│ [16px spacing]                  │
│                                 │
│ [CTA Button]                    │
│ "{petName} 맞춤 사료 보러가기"   │
│ 높이: 54px, radius: 17px        │
│                                 │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### PetCard
- **위치**: 상단 첫 번째 섹션
- **구성**:
  - 이름 (Title 스타일)
  - 나이 · 몸무게 (Sub 스타일, 인라인)
  - 건강 포인트 (Sub, Text Sub 색상)
  - 프로필 수정 (Sub, Primary 색상, underline)
- **카드 없음**: 여백으로만 구분

#### RecommendationCard
- **위치**: PetCard 아래
- **로딩 상태**: "분석 중..." 텍스트 + 스켈레톤
- **빈 상태**: "추천 준비 중" + "곧 맞춤 추천을 드릴게요!"
- **정상 상태**:
  - 상품명: `{brandName} {productName}` (Body)
  - 가격: `{price}원` (Price Numeric, 24px, Bold)
  - MetricRow: "평균 대비 -X.X%" (Positive/Negative 색상)
  - Helper Text: "최근 14일 기준" (12px, Sub)
  - "왜 추천?" 링크 (Sub, Primary, underline)

#### 판단 문장 (조건부)
- **조건**: `currentPrice < averagePrice` 일 때만 표시
- **스타일**: Sub, Text Sub 색상
- **위치**: RecommendationCard와 CTA 버튼 사이

#### CTA Button
- **텍스트**: "{petName} 맞춤 사료 보러가기"
- **스타일**: 
  - 높이: 54px (52~56 범위)
  - Border Radius: 17px (16~18 범위)
  - 배경: Primary
  - 텍스트: Body, Bold, White
- **액션**: 추천 상품 상세 페이지로 이동

### 데이터 구조

```dart
HomeState {
  petSummary: PetSummaryDto? {
    name: String
    ageSummary: String
    weightKg: double
    healthSummary: String
  }
  recommendations: RecommendationDto? {
    items: List<RecommendationItemDto> {
      product: ProductDto
      currentPrice: int
      averagePrice: int
      deltaPercent: double?
    }
  }
  isLoading: bool
  error: String?
}
```

### 상태별 UI

1. **Pet 있음 + 추천 있음**: 정상 홈 (위 레이아웃)
2. **Pet 있음 + 추천 없음**: "추천 준비 중" 메시지
3. **Pet 없음**: Empty State (프로필 추가 유도)

### 피그마 디자인 시 고려사항

- ✅ 카드 배경/테두리/그림자 없음
- ✅ 섹션 간 28px spacing으로만 구분
- ✅ 숫자(가격, 퍼센트)는 Hero/Price Numeric 스타일로 강조
- ✅ 판단 문장은 보조적으로 표시 (Sub 색상)
- ✅ CTA 버튼은 화면 하단에 고정하지 않음 (스크롤 가능)

---

## 3. 찜한 사료 화면 (Watch/Favorites Screen)

### 화면 목적
- 찜한 사료 목록을 "구매 판단 대기열"로 표시
- 정렬/필터 기능으로 구매 타이밍 판단 지원

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ AppBar                          │
│ "찜한 사료"                      │
├─────────────────────────────────┤
│                                 │
│ [요약 영역]                      │
│ "찜한 사료 {n}개" (Title)        │
│                                 │
│ "지금 평균보다 저렴한 사료"      │
│ "{k}개" (Hero Number, Positive) │
│ " 있어요"                        │
│ 또는                            │
│ "지금은 평균가와 비슷한 시기예요" │
│                                 │
│ [24px spacing]                  │
│                                 │
│ [정렬 칩]                        │
│ [저렴한 순] [가격 변동 낮은 순] [인기순] │
│                                 │
│ [24px spacing]                  │
│                                 │
│ [ProductTile Grid]              │
│ ┌──────┐ ┌──────┐              │
│ │ Tile │ │ Tile │              │
│ └──────┘ └──────┘              │
│ ┌──────┐ ┌──────┐              │
│ │ Tile │ │ Tile │              │
│ └──────┘ └──────┘              │
│                                 │
│ Grid: 2열, aspectRatio: 0.72   │
│ spacing: 16px                   │
│                                 │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### 요약 영역
- **위치**: AppBar 바로 아래
- **패딩**: 좌우 16px, 상 16px, 하 24px
- **구성**:
  - "찜한 사료 {n}개" (Title)
  - 조건부: 저렴한 상품이 있으면
    - "지금 평균보다 저렴한 사료" (Body Main)
    - "{k}개" (Hero Number, 28px, Positive 색상)
    - " 있어요" (Body Main)
  - 조건부: 없으면
    - "지금은 평균가와 비슷한 시기예요" (Body Main, Text Sub)

#### 정렬 칩
- **위치**: 요약 영역 아래
- **패딩**: 좌우 16px, 상하 16px
- **옵션**:
  - "저렴한 순" (SortOption.priceLow)
  - "가격 변동 낮은 순" (SortOption.priceStable)
  - "인기순" (SortOption.popular)
- **스타일**: ChoiceChip, 선택 시 Primary 색상

#### ProductTile Grid
- **레이아웃**: 2열 그리드
- **Aspect Ratio**: 0.72
- **Spacing**: 16px (crossAxis, mainAxis)
- **각 타일**:
  - ProductTile 컴포넌트 사용
  - statusText: "평균 대비 -8%", "최저가 근처" 등

### 데이터 구조

```dart
WatchState {
  trackingProducts: List<TrackingProductData> {
    id: String
    title: String
    brandName: String
    priceValue: int
    avgPrice: int
    deltaPercent: double
    isNewLow: bool
    statusLabel: String // "평균 대비 -8%", "최저가 근처"
  }
  sortOption: SortOption // priceLow, priceStable, popular
  cheaperCount: int
  isLoading: bool
  error: String?
}
```

### 정렬 로직

- **저렴한 순**: `priceValue` 오름차순
- **가격 변동 낮은 순**: `deltaPercent.abs()` 오름차순
- **인기순**: 임시로 알림 켜진 순

### Empty State

- **아이콘**: favorite_border (64px, Text Sub 50% opacity)
- **타이틀**: "아직 찜한 사료가 없어요" (Title)
- **설명**: "사료를 찜하고 가격 알림을 받아보세요" (Sub)
- **CTA**: "핫딜 보러가기" 버튼 (Primary, Market 화면으로 이동)

### 피그마 디자인 시 고려사항

- ✅ 요약 영역은 숫자 중심 (Hero Number 스타일)
- ✅ 정렬 칩은 가로 스크롤 가능
- ✅ ProductTile은 카드 배경 없이 이미지+텍스트만
- ✅ 상태 라벨은 작은 텍스트 (12px)로 표시

---

## 4. 사료마켓 화면 (Market Screen)

### 화면 목적
- 사료 탐색 및 검색
- 핫딜, 인기 상품, 카테고리별 탐색

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ SliverAppBar (pinned)           │
│ "사료마켓" + [알림] [설정]       │
├─────────────────────────────────┤
│                                 │
│ [검색 바]                        │
│ 높이: 48px, radius: 16px        │
│ 배경: White, border: 연한 Divider │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "오늘의 핫딜"                    │
│ "지금 가장 저렴한 사료"          │
│ [더보기 >]                       │
│                                 │
│ [HorizontalProductList]          │
│ ┌──┐ ┌──┐ ┌──┐ ┌──┐            │
│ │  │ │  │ │  │ │  │            │
│ └──┘ └──┘ └──┘ └──┘            │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "실시간 인기 사료"               │
│ "지금 많이 찾는 사료"            │
│ [더보기 >]                       │
│                                 │
│ [HorizontalProductList]          │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [RecommendBannerCard]            │
│ (맞춤 추천 배너)                 │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "카테고리"                       │
│                                 │
│ [CategoryChips]                  │
│ [전체] [건강식] [다이어트] ...   │
│                                 │
│ [28px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "전체 사료"                      │
│ "{n}개 상품"                     │
│                                 │
│ [ProductGrid]                    │
│ ┌──────┐ ┌──────┐              │
│ │ Tile │ │ Tile │              │
│ └──────┘ └──────┘              │
│ ┌──────┐ ┌──────┐              │
│ │ Tile │ │ Tile │              │
│ └──────┘ └──────┘              │
│                                 │
│ Grid: 2열, aspectRatio: 0.72    │
│ spacing: 16px                   │
│                                 │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### SliverAppBar
- **pinned**: true (스크롤 시 상단 고정)
- **타이틀**: "사료마켓" (Title)
- **액션**: 알림 아이콘, 설정 아이콘
- **배경**: Background 색상

#### 검색 바
- **위치**: AppBar 아래
- **패딩**: 좌우 16px, 상 16px, 하 24px
- **스타일**:
  - 높이: 48px
  - Border Radius: 16px
  - 배경: Surface (White)
  - Border: 1px, Divider 50% opacity
  - Placeholder: "사료 브랜드나 제품명을 검색하세요" (Sub)
  - Prefix Icon: search (20px, Icon Muted)
  - Suffix Icon: clear (검색어 있을 때만)

#### SectionHeader
- **섹션 1**: "오늘의 핫딜" + "지금 가장 저렴한 사료" + 더보기
- **섹션 2**: "실시간 인기 사료" + "지금 많이 찾는 사료" + 더보기
- **섹션 3**: "카테고리" (서브타이틀 없음)
- **섹션 4**: "전체 사료" + "{n}개 상품" (trailingText)

#### HorizontalProductList
- **레이아웃**: 가로 스크롤 ListView
- **아이템**: ProductTile 컴포넌트
- **패딩**: 좌우 16px
- **Spacing**: 16px

#### CategoryChips
- **레이아웃**: 가로 스크롤 가능
- **스타일**: ChoiceChip
- **선택 시**: Primary 색상
- **옵션**: "전체", "건강식", "다이어트", "다이어트", "알레르기 케어" 등

#### ProductGrid
- **레이아웃**: 2열 그리드
- **Aspect Ratio**: 0.72
- **Spacing**: 16px
- **아이템**: ProductTile 컴포넌트

### 데이터 구조

```dart
MarketState {
  hotDealProducts: List<ProductCardData>
  popularProducts: List<ProductCardData>
  categories: List<Category>
  selectedCategoryId: String?
  allProducts: List<ProductCardData>
  searchQuery: String?
  isLoading: bool
  error: String?
}
```

### 상호작용

- **검색**: 실시간 필터링 (onChanged)
- **카테고리 선택**: 그리드 필터링
- **상품 탭**: 상품 상세 페이지로 이동
- **더보기**: 각 섹션별 상세 페이지 (TODO)

### 피그마 디자인 시 고려사항

- ✅ SliverAppBar는 스크롤 시 상단에 고정
- ✅ 섹션 간 28px spacing으로만 구분 (Divider 없음)
- ✅ 가로 스크롤 리스트는 좌우 패딩 16px
- ✅ 검색 바는 연한 border로 구분
- ✅ ProductTile은 카드 배경 없음

---

## 5. 상품 상세 화면 (Product Detail Screen)

### 화면 목적
- 상품 정보 및 가격 변동 그래프로 구매 판단 지원
- "판단 중심 UI" (토스 스타일)

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ AppBar                          │
│ "상품 상세" + [뒤로]             │
├─────────────────────────────────┤
│                                 │
│ [ProductHeroSection]            │
│ - 상품 이미지 (300px 높이)       │
│ - 상품명 (Title, 24px)          │
│ - 브랜드 · 사이즈 (Body, 회색)   │
│ - 현재 가격 (Hero Number, 28px)  │
│ - 평균 대비 상태 문장            │
│   "X원 저렴해요" (Positive)      │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [PriceGraphSection]             │
│ - "가격 변동 그래프" (Title)     │
│ - 그래프 영역 (200px 높이)       │
│   (카드 없이, 배경만)            │
│ - 숫자 요약 (최저가/평균가/최고가) │
│                                 │
│ [24px spacing]                  │
│                                 │
│ [AlertCtaSection]               │
│ - "이 가격을 놓치지 않으려면?"   │
│ - [가격 알림 받기] 버튼          │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [IngredientAnalysisSection]      │
│ - 성분 분석 정보                 │
│                                 │
├─────────────────────────────────┤
│ [Sticky Bottom Bar]             │
│ [+ 관심] [최저가 구매하기]       │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### ProductHeroSection
- **상품 이미지**:
  - 크기: 전체 너비, 높이 300px
  - Border Radius: 16px
  - Placeholder: image_outlined 아이콘 (80px)
- **상품명**: Title 스타일, 24px, Bold
- **브랜드 · 사이즈**: Body, 16px, 회색
- **현재 가격**: Hero Number 스타일, 28px, Bold
- **평균 대비 상태**:
  - 조건: `currentPrice < averagePrice`
  - 표시: "최근 14일 평균 {avgPrice} 대비"
  - 화살표 + "{diff}원 저렴해요" (Positive 색상)
- **좋은 가격 배지** (조건부):
  - 배경: Positive 10% opacity
  - 아이콘: check_circle (16px, Positive)
  - 텍스트: "우리 아이에게 좋은 가격이에요" (14px, Positive, Bold)

#### PriceGraphSection
- **제목**: "가격 변동 그래프" (Title, 22px, Bold)
- **서브타이틀**: "최근 가격 흐름을 한눈에 확인하세요" (13px, 회색)
- **그래프 영역**:
  - 높이: 200px
  - 배경: 회색 50 (카드 없음)
  - Border Radius: 12px
  - 그래프: 선 그래프 (최저가: 초록, 평균: 회색, 최고가: 연한 빨강)
  - 그리드/배경선 최소화
- **숫자 요약** (그래프 아래):
  - 최저가 (Positive 색상)
  - 평균가 (회색)
  - 최고가 (연한 빨강)
  - 레이아웃: 가로 배치, 균등 분할

#### AlertCtaSection
- **문맥형 CTA**:
  - 문장: "이 가격을 놓치지 않으려면?" (Body)
  - 버튼: "[가격 알림 받기]" (Primary, 높이 52px, radius 16px)
- **상태**:
  - 추적 생성 전: 버튼 활성
  - 추적 생성 후: "알림 설정됨" 텍스트

#### IngredientAnalysisSection
- **성분 분석 정보**:
  - 단백질, 지방, 탄수화물 등
  - 알레르기 유발 성분 표시
  - 건강 고민별 적합성

#### Sticky Bottom Bar
- **위치**: 화면 하단 고정
- **구성**:
  - 좌측: "+ 관심" 버튼 (Secondary)
  - 우측: "최저가 구매하기" 버튼 (Primary)
- **높이**: 56px + SafeArea

### 데이터 구조

```dart
ProductDetailState {
  product: ProductDto? {
    productName: String
    brandName: String
    sizeLabel: String?
    imageUrl: String?
  }
  currentPrice: int?
  averagePrice: int?
  minPrice: int?
  maxPrice: int?
  priceHistory: List<PriceDataPoint>?
  trackingCreated: bool
  isTrackingLoading: bool
  isFavorite: bool
  purchaseUrl: String?
  ingredientAnalysis: IngredientAnalysis?
  isLoading: bool
  error: String?
}
```

### 피그마 디자인 시 고려사항

- ✅ Hero 영역은 카드 없이 여백으로만 구분
- ✅ 가격은 Hero Number 스타일로 강조
- ✅ 그래프는 카드 안에 넣지 않음 (핵심 콘텐츠)
- ✅ 그래프 선은 얇게, 색상 최소화
- ✅ 숫자 요약은 그래프 바로 아래 배치
- ✅ 하단 바는 sticky (스크롤 시 하단 고정)

---

## 6. 혜택 화면 (Benefits Screen)

### 화면 목적
- 포인트 및 미션 시스템
- "숫자(포인트) 중심 + 미션 리스트" (토스 스타일)

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ AppBar                          │
│ "혜택"                          │
├─────────────────────────────────┤
│                                 │
│ [Hero 포인트 영역]               │
│ "내 포인트" (Title)              │
│ "0 P" (Hero Number)             │
│ "미션을 완료하면 포인트가 쌓여요" │
│ (Sub)                           │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "미션"                           │
│ "완료하면 포인트를 받을 수 있어요" │
│                                 │
│ [MissionTile]                   │
│ [아이콘] [미션명/설명] [100P 받기] │
│                                 │
│ [MissionTile]                   │
│ [아이콘] [미션명/설명] [50P 받기] │
│                                 │
│ [MissionTile]                   │
│ [아이콘] [미션명/설명] [완료됨]   │
│                                 │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### Hero 포인트 영역
- **위치**: AppBar 아래
- **패딩**: 좌우 16px, 상 16px, 하 32px
- **구성**:
  - "내 포인트" (Title)
  - "0 P" (Hero Number, 38px, Bold)
  - "미션을 완료하면 포인트가 쌓여요" (Sub)

#### MissionTile
- **레이아웃**: Row (좌측 아이콘 + 가운데 텍스트 + 우측 버튼)
- **패딩**: 좌우 16px, 상하 8px
- **구성**:
  - **좌측 아이콘**:
    - 크기: 40x40px
    - 배경: Primary Soft
    - Border Radius: 10px
    - 아이콘: 20px, Primary 색상
  - **가운데 텍스트**:
    - 미션명: Body, Bold
    - 설명: Sub
    - 완료 상태: 체크 아이콘 (16px, Positive) + "완료" 배지
  - **우측 버튼**:
    - 미완료: "100P 받기" (Primary, 높이 36px, radius 13px)
    - 완료: "완료됨" (Surface 배경, Border, Text Sub)

### 데이터 구조

```dart
MissionData {
  id: String
  title: String
  description: String
  points: int
  icon: IconData
  isCompleted: bool
  onTap: VoidCallback
}
```

### 피그마 디자인 시 고려사항

- ✅ 포인트는 Hero Number로 강조
- ✅ 미션 리스트는 ListTile 스타일 (카드 없음)
- ✅ 완료 상태는 체크 아이콘 + 배지로 표시
- ✅ CTA 버튼은 작게 (36px 높이)

---

## 7. 마이 화면 (My/Me Screen)

### 화면 목적
- 프로필 및 설정 관리
- "상태 요약 → 프로필 → 설정" 흐름 (토스 스타일)

### 레이아웃 구조

```
┌─────────────────────────────────┐
│ AppBar                          │
│ "마이"                           │
├─────────────────────────────────┤
│                                 │
│ [상태 요약]                      │
│ "{petName}의 건강 리포트"        │
│ (Title)                         │
│                                 │
│ [상태 Pill]                     │
│ [✓] "특이사항 없이 건강해요"     │
│ (Positive 배경 10%, 20px radius) │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "프로필"                         │
│                                 │
│ [ProfileItem]                   │
│ 견종: 강아지                     │
│                                 │
│ [ProfileItem]                   │
│ 체중: 5.2kg                      │
│                                 │
│ [ProfileItem]                   │
│ 나이: 3살                        │
│                                 │
│ "프로필 수정" (링크)             │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "알림 설정"                      │
│ "가격 변동과 추천을 알려드려요"  │
│                                 │
│ [SettingItem]                   │
│ 가격 알림 / 최저가일 때 알려드려요 │
│ [Switch]                        │
│                                 │
│ [SettingItem]                   │
│ 푸시 알림 / 앱 푸시 알림 받기    │
│ [Switch]                        │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [SectionHeader]                 │
│ "포인트"                       │
│                                 │
│ "0 P" (Hero Number)             │
│ "사료 구매 시 포인트를 적립할 수 있습니다" │
│ (Sub)                           │
│                                 │
└─────────────────────────────────┘
```

### 주요 컴포넌트

#### 상태 요약
- **위치**: AppBar 아래
- **패딩**: 좌우 16px, 상 16px, 하 32px
- **구성**:
  - "{petName}의 건강 리포트" (Title)
  - 상태 Pill:
    - 배경: Positive 10% opacity
    - Border Radius: 20px
    - 아이콘: check_circle (16px, Positive)
    - 텍스트: "특이사항 없이 건강해요" (Sub, Positive, Bold)

#### ProfileItem
- **레이아웃**: Row (좌우 정렬)
- **구성**:
  - Label: Sub, Text Sub 색상
  - Value: Body, Medium
- **항목**: 견종, 체중, 나이

#### SettingItem
- **레이아웃**: Row (좌측 텍스트 + 우측 Switch)
- **구성**:
  - Title: Body, Bold
  - Subtitle: Sub (4px 아래)
  - Switch: Primary 색상

#### 포인트 섹션
- **구성**:
  - "0 P" (Hero Number)
  - "사료 구매 시 포인트를 적립할 수 있습니다" (Sub)

### 데이터 구조

```dart
// HomeState에서 petSummary 가져옴
PetSummaryDto {
  name: String
  species: String // 'DOG' | 'CAT'
  weightKg: double
  ageSummary: String
  healthSummary: String
}
```

### 피그마 디자인 시 고려사항

- ✅ 상태 요약은 Pill 스타일로 강조
- ✅ 프로필 항목은 리스트 형태 (카드 없음)
- ✅ 설정 항목은 Switch로 토글
- ✅ 포인트는 Hero Number로 강조
- ✅ 섹션 간 32px spacing

---

## 8. 온보딩 화면 (Onboarding)

### 화면 목적
- 반려동물 프로필 설정
- 11~12단계 플로우 (강아지 12단계, 고양이 11단계)

### 레이아웃 구조 (공통)

```
┌─────────────────────────────────┐
│ [ProgressBar]                   │
│ (4px 높이, Primary 색상)         │
├─────────────────────────────────┤
│ [뒤로가기 버튼] (첫 화면 제외)   │
├─────────────────────────────────┤
│                                 │
│ [이모지] (56px)                  │
│                                 │
│ [제목] (Title)                  │
│                                 │
│ [서브타이틀] (Sub, 선택)         │
│                                 │
│ [32px spacing]                  │
│                                 │
│ [컨텐츠 영역]                   │
│ (입력/선택 UI)                   │
│                                 │
├─────────────────────────────────┤
│ [CTA Button]                    │
│ 높이: 56px, radius: 16px        │
│                                 │
└─────────────────────────────────┘
```

### 단계별 상세

#### Step 1: 닉네임
- **이모지**: 👋
- **제목**: "What should we call you?"
- **서브타이틀**: "Enter a nickname to get started"
- **컨텐츠**: TossTextInput (닉네임 입력, 2-12자)
- **Helper**: "2–12 characters" (Sub)

#### Step 2: 아이 이름
- **이모지**: 🐾
- **제목**: "What's your pet's name?"
- **서브타이틀**: "Let us know what to call your furry friend"
- **컨텐츠**: TossTextInput (1-20자)

#### Step 3: 종 선택
- **이모지**: 🐶
- **제목**: "What kind of pet do you have?"
- **서브타이틀**: "Select your pet's species"
- **컨텐츠**: SelectionCard 2개 (강아지 🐶, 고양이 🐱)

#### Step 4: 나이 정보
- **이모지**: 📅
- **제목**: "How old is your pet?"
- **서브타이틀**: "Choose how you'd like to enter their age"
- **컨텐츠**: 
  - SelectionCard 2개 (생년월일 📅, 대략 나이 🎈)
  - 조건부: DatePicker 또는 나이 입력 필드

#### Step 5: 품종 (강아지만)
- **이모지**: 🦴
- **제목**: "What breed is your dog?"
- **서브타이틀**: "Enter your dog's breed or mix"
- **컨텐츠**: TossTextInput (품종 입력)

#### Step 6: 성별 + 중성화
- **이모지**: ⚧️
- **제목**: "Tell us about your pet"
- **서브타이틀**: "Select sex and neutered status"
- **컨텐츠**: 
  - 성별: SelectionCard 2개 (남아, 여아)
  - 중성화: SelectionCard 2개 (Yes, No)

#### Step 7: 몸무게
- **이모지**: ⚖️
- **제목**: "What's your pet's weight?"
- **서브타이틀**: "Enter their current weight in kilograms"
- **컨텐츠**: TossTextInput (숫자, 0.1-99.9kg)

#### Step 8: BCS (Body Condition Score)
- **이모지**: 📊
- **제목**: "Body condition score"
- **서브타이틀**: "Rate your pet's body condition from 1 (very thin) to 9 (obese)"
- **컨텐츠**: 
  - 슬라이더 (1-9)
  - 현재 값 표시 (Hero Number, Primary 색상)
  - 라벨 (Underweight/Ideal/Overweight/Obese)
  - 설명 리스트 (1-3, 4-5, 6-7, 8-9)

#### Step 9: 건강 고민
- **이모지**: 🏥
- **제목**: "Any health concerns?"
- **서브타이틀**: "Select all that apply to your pet"
- **컨텐츠**: PillChip 그리드 (Wrap)
  - "None" (독점 옵션)
  - "Allergies", "Arthritis", "Diabetes" 등

#### Step 10: 음식 알레르기
- **이모지**: 🍖
- **제목**: "Any food allergies?"
- **서브타이틀**: "Select all ingredients your pet is allergic to"
- **컨텐츠**: 
  - PillChip 그리드
  - "Other" 선택 시 텍스트 입력 필드

#### Step 11: 사진
- **이모지**: 📸
- **제목**: "Add a photo of {petName}"
- **서브타이틀**: "Help us recognize your pet (optional)"
- **컨텐츠**: 
  - 사진 없음: 업로드 플레이스홀더 (256px 높이, dashed border)
  - 사진 있음: 이미지 미리보기 (256px, Primary border)
- **CTA**: 
  - 사진 없음: "Skip for now"
  - 사진 있음: "Complete setup" + "Change photo" (Secondary)

### 분기 로직

- **강아지**: 12단계 (품종 단계 포함)
- **고양이**: 11단계 (품종 단계 스킵)
- **진행률 바**: 종에 따라 총 단계 수 조정

### 데이터 구조

```dart
OnboardingStateV2 {
  nickname: String (2-12자)
  petName: String (1-20자)
  species: String ('dog' | 'cat' | '')
  ageType: String ('birthdate' | 'approximate' | '')
  birthdate: String
  approximateAge: String
  breed: String (강아지만)
  sex: String ('male' | 'female' | '')
  neutered: bool? (true | false | null)
  weight: String (0.1-99.9kg)
  bcs: int (1-9, 기본값 5)
  healthConcerns: List<String>
  foodAllergies: List<String>
  otherAllergy: String
  photo: String (base64 또는 파일 경로)
}
```

### 피그마 디자인 시 고려사항

- ✅ ProgressBar는 상단 고정
- ✅ 화면은 중앙 정렬, 최대 너비 375px
- ✅ 카드 배경은 흰색, 약한 그림자
- ✅ SelectionCard는 선택 시 Primary Soft 배경
- ✅ PillChip은 선택 시 Primary 배경
- ✅ CTA 버튼은 하단 고정

---

## 📐 공통 컴포넌트 스펙

### ProgressBar
- **높이**: 4px
- **배경**: Divider
- **진행 바**: Primary
- **Border Radius**: 2px
- **애니메이션**: 300ms ease-out

### PrimaryCTAButton
- **높이**: 56px
- **Border Radius**: 16px
- **패딩**: 좌우 24px
- **Primary**: Primary 배경, White 텍스트
- **Secondary**: White 배경, Primary 텍스트, Border

### TossTextInput
- **높이**: 56px
- **Border Radius**: 12px
- **배경**: Background (포커스 시 Surface)
- **Border**: 2px, 포커스 시 Primary
- **텍스트**: Body 스타일
- **Placeholder**: Sub 스타일, Text Sub 색상

### SelectionCard
- **최소 높이**: 72px
- **Border Radius**: 16px
- **패딩**: 좌우 20px, 상하 16px
- **미선택**: Background 배경, 투명 border
- **선택**: Primary Soft 배경, Primary border (2px)
- **체크마크**: 24x24px 원, Primary 배경

### PillChip
- **높이**: 44px
- **Border Radius**: 22px
- **패딩**: 좌우 20px, 상하 12px
- **미선택**: Background 배경, Text Main 텍스트
- **선택**: Primary 배경, White 텍스트

---

## 🎯 피그마 디자인 체크리스트

### 필수 작업

- [ ] 모든 화면 와이어프레임 (7개 주요 화면)
- [ ] 공통 컴포넌트 라이브러리 (SectionHeader, MetricRow, ProductTile 등)
- [ ] 디자인 시스템 적용 (색상, 타이포그래피)
- [ ] 상태별 UI (로딩, 에러, 빈 상태)
- [ ] 반응형 레이아웃 (모바일 375px 기준)
- [ ] 인터랙션 스펙 (터치 영역, 애니메이션)

### 권장 작업

- [ ] 프로토타입 (화면 전환, 인터랙션)
- [ ] 다크모드 고려 (선택)
- [ ] 접근성 (최소 터치 영역 44x44px)
- [ ] 에러 상태 디자인
- [ ] 로딩 상태 디자인 (스켈레톤)

---

## 📝 주요 원칙

1. **토스 스타일**: 카드/구분선 없이 여백으로만 구분
2. **숫자 중심**: 중요한 수치는 Hero/Price Numeric 스타일로 강조
3. **판단 UI**: 상품 상세는 "구매 판단 페이지"로 설계
4. **여백 활용**: 24~32px spacing으로 정보 위계 표현
5. **미니멀**: 불필요한 장식 제거, 콘텐츠에 집중

---

**Made with ❤️ for HeyZeno**

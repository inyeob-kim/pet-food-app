# 더미 데이터 가이드

각 화면별로 사용할 수 있는 더미 데이터를 제공합니다.

## 화면별 더미 데이터

### 1. 홈 화면 (`home_mock_data.dart`)
- `noProfile`: 프로필 없음 상태
- `profileWithoutFood`: 프로필 있음 + 사료 미등록
- `registeredFoodStatus`: 사료 등록됨 상태 (핵심 상태 카드용)
- `daysUntilEmpty`: 소진까지 남은 일수
- `todayGoodDeals`: 오늘 사면 좋은 사료 리스트 (2~4개)
- `isPriceAlertEnabled`: 가격 알림 설정 여부

### 2. 관심 화면 (`watch_mock_data.dart`)
- `trackingList`: 추적 중인 사료 카드 리스트
- `TrackingWithProduct`: 추적 정보 + 상품 정보 결합 모델
- `priceContext`: 가격 맥락 텍스트 (평균 대비, 상승/하락 등)

### 3. 사료 선택 화면 (`product_browse_mock_data.dart`)
- `popularProducts`: 대표 사료 그리드 (200개)
- `filterOptions`: 필터 옵션 (연령, 체형, 니즈)
- `ProductCardData`: 상품 카드 데이터 (태그, 인기 여부 등)

### 4. 사료 상세 화면 (`product_detail_mock_data.dart`)
- `detail`: 상세 정보 데이터
- `ProductDetailData`: 상세 정보 모델
  - 가격 정보 (현재가, 평균가, 변동률)
  - 가격 안정성 (유지 일수)
  - 우리 아이 기준 계산 (급여 일수)
  - 정기배송 판단 정보

### 5. 알림 화면 (`alert_mock_data.dart`)
- `priceDropAlerts`: 가격 하락 알림 리스트
- `lowStockAlerts`: 소진 임박 알림 리스트
- `allAlerts`: 모든 알림 (가격 + 소진)
- `AlertItem`: 알림 아이템 모델

### 6. 마이 화면 (`me_mock_data.dart`)
- `petProfile`: 반려동물 프로필
- `notificationSettings`: 알림 설정
- `points`: 포인트
- `getBreedName()`: 견종 코드 → 이름 변환

## 사용 예시

```dart
// 홈 화면
final status = HomeMockData.registeredFoodStatus;
final daysLeft = HomeMockData.daysUntilEmpty;

// 관심 화면
final trackings = WatchMockData.trackingList;
final context = trackings[0].priceContext; // "이 가격은 평균보다 16.7% 저렴해요"

// 사료 선택 화면
final products = ProductBrowseMockData.popularProducts;
final filters = ProductBrowseMockData.filterOptions;

// 사료 상세 화면
final detail = ProductDetailMockData.detail;
final description = detail.petBasedDescription; // "12kg, 하루 120g 기준\n약 25일 급여 가능"

// 알림 화면
final alerts = AlertMockData.allAlerts;

// 마이 화면
final profile = MeMockData.petProfile;
final settings = MeMockData.notificationSettings;
```

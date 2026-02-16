# 앱 전체 소스 리팩토링 분석 보고서

## 📋 분석 개요

전체 코드베이스를 분석하여 다음 항목들을 점검했습니다:
1. 화면/라우터에 도메인 로직이 있는지
2. 비효율적인 코드 패턴
3. 중복 코드 및 재사용 가능한 위젯
4. 레이어 분리 준수 여부

---

## 🔴 1. 화면/라우터에 도메인 로직이 있는 경우

### 1.1 HomeScreen (`frontend/lib/features/home/presentation/screens/home_screen.dart`)

#### 문제점 1: 나이 계산 로직이 화면에 있음
**위치**: Line 757-772
```dart
// 나이 정보 생성
String? ageText;
if (petSummary.ageMonths != null) {
  if (petSummary.ageMonths! < 12) {
    ageText = '${petSummary.ageMonths}개월';
  } else {
    final years = petSummary.ageMonths! ~/ 12;
    final months = petSummary.ageMonths! % 12;
    if (months == 0) {
      ageText = '${years}살';
    } else {
      ageText = '${years}살 ${months}개월';
    }
  }
} else if (petSummary.ageStage != null) {
  ageText = PetConstants.getAgeStageText(petSummary.ageStage);
}
```
**해결 방안**: `PetSummaryDto`에 extension 메서드 추가 또는 `PetService`에 `formatAge()` 메서드 추가

#### 문제점 2: 중성화 텍스트 변환 로직이 화면에 있음
**위치**: Line 778-782
```dart
String? neuteredText;
if (petSummary.isNeutered != null) {
  neuteredText = petSummary.isNeutered == true ? '중성화 완료' : '중성화 안함';
}
```
**해결 방안**: `PetService`에 `formatNeuteredStatus()` 메서드 추가

#### 문제점 3: 데이터 필터링/변환 로직이 화면에 있음
**위치**: Line 683-685, 776, 527
```dart
final shortReasons = matchReasons
    .where((String reason) => reason.length < 30)
    .take(3)
    .toList();
final displayConcerns = healthConcerns.take(2).toList();
...matchReasons.asMap().entries.map((entry) { ... })
```
**해결 방안**: 컨트롤러나 서비스에서 미리 처리된 데이터 제공

#### 문제점 4: 닉네임 로드 로직이 화면에 있음
**위치**: Line 63-74
```dart
Future<void> _loadUserNickname() async {
  try {
    final nickname = await SecureStorage.read(StorageKeys.draftNickname);
    if (mounted) {
      setState(() {
        _userNickname = nickname;
      });
    }
  } catch (e) {
    print('[HomeScreen] 닉네임 로드 실패: $e');
  }
}
```
**해결 방안**: `HomeController`에서 처리하거나 `UserService` 생성

#### 문제점 5: 추천 자동 펼치기 로직이 화면에 있음
**위치**: Line 98-198
```dart
void _handleAutoExpandRecommendation(HomeState state) {
  // 복잡한 비즈니스 로직이 화면에 있음
  if (topRecommendation == null && !state.isLoadingRecommendations) {
    // ...
  }
}
```
**해결 방안**: `HomeController`로 이동

### 1.2 MarketScreen (`frontend/lib/features/market/presentation/screens/market_screen.dart`)

#### 문제점 1: 하트 클릭 핸들러에 비즈니스 로직이 있음
**위치**: Line 270-305
```dart
Future<void> _handleHeartTap(String productId, bool isTracked, String petId) async {
  final watchController = ref.read(watchControllerProvider.notifier);
  
  if (isTracked) {
    final success = await watchController.removeTracking(productId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  } else {
    final success = await watchController.addTracking(productId, petId);
    // ...
  }
}
```
**해결 방안**: `MarketController`에 메서드 추가하여 처리

### 1.3 AppRouter (`frontend/lib/app/router/app_router.dart`)

#### 문제점 1: 온보딩 체크 로직이 라우터에 있음
**위치**: Line 47-79
```dart
redirect: (context, state) async {
  // 온보딩 서비스를 통해 완료 여부 확인
  final onboardingService = ref.read(onboardingServiceProvider);
  final isCompleted = await onboardingService.isOnboardingCompleted();
  // ...
}
```
**해결 방안**: 라우터 가드 미들웨어로 분리하거나 별도 서비스로 추출

#### 문제점 2: 라우터에서 데이터 검증 로직이 있음
**위치**: Line 118-150
```dart
builder: (context, state) {
  final petSummary = state.extra as PetSummaryDto?;
  if (petSummary == null) {
    return const HomeScreen();
  }
  // ...
}
```
**해결 방안**: 라우터 레벨에서 처리하거나 별도 검증 서비스 사용

---

## 🟡 2. 중복 코드

### 2.1 버튼 위젯 중복

#### 중복 1: PrimaryButton이 3개 버전으로 존재
1. `frontend/lib/ui/widgets/app_buttons.dart` - `AppPrimaryButton`
2. `frontend/lib/core/widgets/primary_button.dart` - `PrimaryButton`
3. `frontend/lib/ui/widgets/figma_primary_button.dart` - `FigmaPrimaryButton`

**문제점**: 각각 다른 스타일과 동작 방식
**해결 방안**: 하나로 통합하거나 명확한 사용 가이드라인 작성

### 2.2 ProductCard 중복

#### 중복 1: ProductCard가 2개 존재
1. `frontend/lib/features/home/presentation/widgets/product_card.dart` - `RecommendationItemDto` 사용
2. `frontend/lib/features/market/presentation/widgets/product_card.dart` - `ProductCardData` 사용

**문제점**: 비슷한 기능이지만 다른 데이터 모델 사용
**해결 방안**: 공통 `ProductCard` 위젯 생성 후 어댑터 패턴 적용

### 2.3 EmptyState 위젯 중복

#### 중복 1: EmptyState 관련 위젯
1. `frontend/lib/core/widgets/empty_state.dart` - `EmptyStateWidget`
2. `frontend/lib/ui/widgets/figma_empty_state.dart` - `FigmaEmptyState`
3. `frontend/lib/features/home/presentation/widgets/today_empty_state.dart` - `TodayEmptyState`

**문제점**: 비슷한 목적이지만 다른 구현
**해결 방안**: 하나로 통합하거나 명확한 역할 분리

### 2.4 컨트롤러에서 중복 로직

#### 중복 1: hasRecent 계산 로직이 중복
**위치**: 
- `home_controller.dart` Line 149-150, 214-215
```dart
final hasRecent = isCached || 
    (lastRecommendedAt != null && DateTime.now().difference(lastRecommendedAt).inDays <= 7);
```
**해결 방안**: `RecommendationResponseDto`에 extension 메서드 추가 또는 유틸리티 함수로 추출

### 2.5 데이터 변환 로직 중복

#### 중복 1: ProductDto → ProductCardData 변환
**위치**: `market_controller.dart` Line 174-190
```dart
List<ProductCardData> _convertToProductCards(List<ProductDto> products, ...) {
  return products.map((product) {
    return ProductCardData(...);
  }).toList();
}
```
**해결 방안**: `ProductMapper` 유틸리티로 추출 (이미 `data/utils/product_mapper.dart` 존재)

---

## 🟠 3. 비효율적인 코드 패턴

### 3.1 불필요한 데이터 변환

#### 문제점 1: MarketController에서 ProductCardData로 변환
**위치**: `market_controller.dart` Line 80, 106
```dart
final productCards = _convertToProductCards(products, trackedProductIds: trackedIds);
```
**문제점**: DTO를 또 다른 모델로 변환하는 불필요한 레이어
**해결 방안**: `ProductCard` 위젯이 `ProductDto`를 직접 받도록 수정

### 3.2 중복 상태 업데이트

#### 문제점 1: MarketController의 updateTrackingStatus
**위치**: `market_controller.dart` Line 123-172
```dart
void updateTrackingStatus() {
  // 모든 상품 카드의 찜 상태 업데이트
  final updatedAllProducts = state.allProducts.map((product) {
    return ProductCardData(...); // 전체 리스트 재생성
  }).toList();
  // hotDealProducts, popularProducts도 동일하게 처리
}
```
**문제점**: 3개 리스트를 모두 재생성하는 비효율
**해결 방안**: `isTracked`만 업데이트하는 방식으로 변경

### 3.3 불필요한 FutureBuilder

#### 문제점 1: HomeScreen의 _buildNoPetState
**위치**: `home_screen.dart` Line 566-675
```dart
Widget _buildNoPetState(BuildContext context) {
  return FutureBuilder<bool>(
    future: ref.read(onboardingServiceProvider).isOnboardingCompleted(),
    // ...
  );
}
```
**문제점**: 매번 FutureBuilder로 체크하는 비효율
**해결 방안**: `HomeController`에서 상태로 관리

### 3.4 화면에서 직접 계산

#### 문제점 1: 나이/중성화 텍스트 변환
**위치**: `home_screen.dart` Line 757-782
**문제점**: 매번 빌드 시 계산
**해결 방안**: DTO에 getter 추가 또는 컨트롤러에서 미리 계산

---

## 🔵 4. 재사용 가능한 위젯 추출 필요

### 4.1 공통 위젯 후보

1. **PetInfoRow** - 펫 정보 표시 (나이, 체중, 중성화 등)
   - 현재: `home_screen.dart` Line 838-898에 인라인으로 구현
   - 추출 필요: `ui/widgets/pet_info_row.dart`

2. **HealthConcernChips** - 건강 고민 배지
   - 현재: `home_screen.dart` Line 918-925에 인라인으로 구현
   - 추출 필요: `ui/widgets/health_concern_chips.dart`

3. **AllergyList** - 알레르기 목록 표시
   - 현재: `home_screen.dart` Line 1246-1284에 인라인으로 구현
   - 추출 필요: `ui/widgets/allergy_list.dart`

4. **RecommendationPreviewCard** - 추천 상품 미리보기 카드
   - 현재: `home_screen.dart` Line 1573-1612에 중복 구현 (2곳)
   - 추출 필요: `features/home/presentation/widgets/recommendation_preview_card.dart`

5. **LoadingStateWidget** - 로딩 상태 표시
   - 현재: 여러 화면에 중복 구현
   - 추출 필요: `core/widgets/loading_state.dart`

6. **ErrorStateWidget** - 에러 상태 표시
   - 현재: 여러 화면에 중복 구현
   - 추출 필요: `core/widgets/error_state.dart`

---

## 📊 5. 레이어 분리 위반 사항

### 5.1 Presentation → Data 직접 접근

#### 문제점 1: 화면에서 Repository 직접 접근
**위치**: `home_screen.dart` Line 643
```dart
final repository = OnboardingRepositoryImpl();
await repository.clearAll();
```
**해결 방안**: `OnboardingService`를 통해 접근

### 5.2 Presentation → Core 직접 접근

#### 문제점 1: 화면에서 SecureStorage 직접 접근
**위치**: `home_screen.dart` Line 65
```dart
final nickname = await SecureStorage.read(StorageKeys.draftNickname);
```
**해결 방안**: `UserService` 또는 `HomeController`에서 처리

---

## ✅ 6. 개선 우선순위

### 높음 (즉시 수정 필요)
1. ✅ 화면에서 도메인 로직 제거 (나이 계산, 중성화 텍스트 등)
2. ✅ 라우터에서 도메인 로직 제거
3. ✅ 중복 버튼 위젯 통합
4. ✅ 중복 ProductCard 통합

### 중간 (단계적 개선)
5. ✅ 컨트롤러에서 중복 로직 제거
6. ✅ 불필요한 데이터 변환 제거
7. ✅ 공통 위젯 추출 (PetInfoRow, HealthConcernChips 등)

### 낮음 (점진적 개선)
8. ✅ EmptyState 위젯 통합
9. ✅ 코드 스타일 통일
10. ✅ 주석 및 문서화 개선

---

## 🛠️ 7. 구체적인 수정 방안

### 7.1 PetService 확장
```dart
// domain/services/pet_service.dart에 추가
extension PetSummaryFormatter on PetSummaryDto {
  String? get formattedAge {
    if (ageMonths != null) {
      if (ageMonths! < 12) {
        return '${ageMonths}개월';
      } else {
        final years = ageMonths! ~/ 12;
        final months = ageMonths! % 12;
        if (months == 0) {
          return '${years}살';
        } else {
          return '${years}살 ${months}개월';
        }
      }
    } else if (ageStage != null) {
      return PetConstants.getAgeStageText(ageStage);
    }
    return null;
  }
  
  String? get formattedNeuteredStatus {
    if (isNeutered == null) return null;
    return isNeutered == true ? '중성화 완료' : '중성화 안함';
  }
}
```

### 7.2 공통 ProductCard 위젯 생성
```dart
// ui/widgets/product_card.dart
class ProductCard extends StatelessWidget {
  final ProductDto product;
  final bool isTracked;
  final VoidCallback? onTap;
  final VoidCallback? onHeartTap;
  
  // RecommendationItemDto와 ProductCardData 모두 지원하는 어댑터 패턴
}
```

### 7.3 HomeController 확장
```dart
// home_controller.dart에 추가
Future<void> loadUserNickname() async {
  try {
    final nickname = await SecureStorage.read(StorageKeys.draftNickname);
    // 상태에 추가 필요
  } catch (e) {
    // 에러 처리
  }
}
```

---

## 📝 8. 추가 권장 사항

1. **테스트 코드 작성**: 리팩토링 후 기능 검증을 위한 테스트 추가
2. **문서화**: 각 서비스/컨트롤러의 역할 명확히 문서화
3. **타입 안정성**: null safety 강화 및 옵셔널 체이닝 개선
4. **성능 최적화**: 불필요한 rebuild 방지를 위한 `const` 위젯 활용
5. **에러 처리 통일**: 모든 화면에서 일관된 에러 처리 패턴 적용

---

## 🎯 결론

전체적으로 **Clean Architecture 원칙**을 준수하도록 개선이 필요합니다. 특히:
- 화면/라우터에서 도메인 로직 완전 제거
- 중복 코드 제거 및 재사용 가능한 컴포넌트 추출
- 레이어 간 의존성 명확히 분리

이러한 개선을 통해 **유지보수성**, **테스트 가능성**, **확장성**을 크게 향상시킬 수 있습니다.

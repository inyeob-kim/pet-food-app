import '../models/recommendation_dto.dart';
import '../models/product_dto.dart';
import '../models/pet_dto.dart';
import '../../core/constants/enums.dart';

/// 홈 화면 더미 데이터
class HomeMockData {
  /// 프로필 없음 상태
  static PetDto? get noProfile => null;

  /// 프로필 있음 + 사료 미등록 상태
  static PetDto get profileWithoutFood {
    return PetDto(
      id: 'pet-001',
      userId: 'user-001',
      name: '뽀삐',
      breedCode: 'GOLDEN_RETRIEVER',
      weightBucketCode: '10-15kg',
      ageStage: AgeStage.adult,
      isNeutered: true,
      isPrimary: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  /// 프로필 있음 + 사료 등록됨 상태 (핵심 상태 카드용)
  static RecommendationItemDto get registeredFoodStatus {
    return RecommendationItemDto(
      product: ProductDto(
        id: 'prod-001',
        brandName: '로얄캐닌',
        productName: '미니 어덜트 강아지 사료',
        sizeLabel: '3kg',
        isActive: true,
      ),
      offerMerchant: Merchant.coupang,
      currentPrice: 35000,
      avgPrice: 42000,
      deltaPercent: -16.67,
      isNewLow: true,
    );
  }

  /// 소진까지 D-n 계산 (예: 5일 남음)
  static int get daysUntilEmpty => 5;

  /// 오늘 사면 좋은 사료 리스트 (2~4개)
  static List<RecommendationItemDto> get todayGoodDeals {
    return [
      RecommendationItemDto(
        product: ProductDto(
          id: 'prod-002',
          brandName: '힐스',
          productName: '사이언스 다이어트 어덜트',
          sizeLabel: '5kg',
          isActive: true,
        ),
        offerMerchant: Merchant.coupang,
        currentPrice: 45000,
        avgPrice: 52000,
        deltaPercent: -13.46,
        isNewLow: true,
      ),
      RecommendationItemDto(
        product: ProductDto(
          id: 'prod-003',
          brandName: '퍼피',
          productName: '초이스 어덜트',
          sizeLabel: '2kg',
          isActive: true,
        ),
        offerMerchant: Merchant.naver,
        currentPrice: 28000,
        avgPrice: 32000,
        deltaPercent: -12.5,
        isNewLow: false,
      ),
      RecommendationItemDto(
        product: ProductDto(
          id: 'prod-004',
          brandName: '네츄럴밸런스',
          productName: '리미티드 인그리디언트',
          sizeLabel: '4.5kg',
          isActive: true,
        ),
        offerMerchant: Merchant.coupang,
        currentPrice: 52000,
        avgPrice: 65000,
        deltaPercent: -20.0,
        isNewLow: true,
      ),
      RecommendationItemDto(
        product: ProductDto(
          id: 'prod-005',
          brandName: '오리젠',
          productName: '오리지널 독',
          sizeLabel: '6kg',
          isActive: true,
        ),
        offerMerchant: Merchant.coupang,
        currentPrice: 85000,
        avgPrice: 95000,
        deltaPercent: -10.53,
        isNewLow: false,
      ),
    ];
  }

  /// 가격 알림 설정 여부
  static bool get isPriceAlertEnabled => true;
}

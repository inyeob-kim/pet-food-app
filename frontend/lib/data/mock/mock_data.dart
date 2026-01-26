import '../models/recommendation_dto.dart';
import '../models/product_dto.dart';
import '../../core/constants/enums.dart';

/// 프론트엔드 더미데이터 (레거시 - 호환성 유지)
class MockData {
  /// 추천 상품 더미데이터 (다양한 시나리오)
  static RecommendationResponseDto getRecommendations(String petId) {
    return RecommendationResponseDto(
      petId: petId,
      items: [
        // 할인율 높은 상품
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000001',
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
        ),
        // 평균가와 비슷한 상품
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000002',
            brandName: '힐스',
            productName: '사이언스 다이어트 어덜트',
            sizeLabel: '5kg',
            isActive: true,
          ),
          offerMerchant: Merchant.naver,
          currentPrice: 45000,
          avgPrice: 45000,
          deltaPercent: 0.0,
          isNewLow: false,
        ),
        // 약간 할인된 상품
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000003',
            brandName: '퍼피',
            productName: '초이스 어덜트',
            sizeLabel: '2kg',
            isActive: true,
          ),
          offerMerchant: Merchant.coupang,
          currentPrice: 28000,
          avgPrice: 30000,
          deltaPercent: -6.67,
          isNewLow: false,
        ),
        // 큰 할인 상품
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000004',
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
        // 가격 상승 상품 (참고용)
        RecommendationItemDto(
          product: ProductDto(
            id: '00000000-0000-0000-0000-000000000005',
            brandName: '오리젠',
            productName: '오리지널 독',
            sizeLabel: '6kg',
            isActive: true,
          ),
          offerMerchant: Merchant.naver,
          currentPrice: 85000,
          avgPrice: 80000,
          deltaPercent: 6.25,
          isNewLow: false,
        ),
      ],
    );
  }

  /// 빈 추천 목록 (프로필 없음 시나리오)
  static RecommendationResponseDto getEmptyRecommendations(String petId) {
    return RecommendationResponseDto(
      petId: petId,
      items: [],
    );
  }

  /// 단일 상품 더미데이터
  static ProductDto getProduct(String productId) {
    return ProductDto(
      id: productId,
      brandName: '로얄캐닌',
      productName: '미니 어덜트 강아지 사료',
      sizeLabel: '3kg',
      isActive: true,
    );
  }

  /// 다양한 브랜드 더미데이터
  static List<ProductDto> getPopularProducts() {
    return [
      ProductDto(
        id: 'mock-001',
        brandName: '로얄캐닌',
        productName: '미니 어덜트',
        sizeLabel: '3kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-002',
        brandName: '힐스',
        productName: '사이언스 다이어트',
        sizeLabel: '5kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-003',
        brandName: '퍼피',
        productName: '초이스',
        sizeLabel: '2kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-004',
        brandName: '네츄럴밸런스',
        productName: '리미티드 인그리디언트',
        sizeLabel: '4.5kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-005',
        brandName: '오리젠',
        productName: '오리지널 독',
        sizeLabel: '6kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-006',
        brandName: '아카나',
        productName: '클래식 레드',
        sizeLabel: '6.8kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-007',
        brandName: '웰니스',
        productName: '코어 어덜트',
        sizeLabel: '5.4kg',
        isActive: true,
      ),
      ProductDto(
        id: 'mock-008',
        brandName: '프로플랜',
        productName: '옵티헬스',
        sizeLabel: '3.2kg',
        isActive: true,
      ),
    ];
  }
}

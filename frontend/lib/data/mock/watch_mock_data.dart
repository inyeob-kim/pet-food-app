import '../models/tracking_dto.dart';
import '../models/product_dto.dart';
import '../models/alert_dto.dart';
import '../models/price_summary_dto.dart';
import '../../core/constants/enums.dart';

/// 관심 화면 더미 데이터 (추적 중인 사료)
class WatchMockData {
  /// 추적 중인 사료 카드 리스트
  static List<TrackingWithProduct> get trackingList {
    return [
      TrackingWithProduct(
        tracking: TrackingDto(
          id: 'track-001',
          petId: 'pet-001',
          productId: 'prod-001',
          status: TrackingStatus.active,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        product: ProductDto(
          id: 'prod-001',
          brandName: '로얄캐닌',
          productName: '미니 어덜트 강아지 사료',
          sizeLabel: '3kg',
          isActive: true,
        ),
        currentPrice: 35000,
        avgPrice: 42000,
        deltaPercent: -16.67,
        isNewLow: true,
        priceSummary: PriceSummaryDto(
          offerId: 'offer-001',
          windowDays: 30,
          avgPrice: 42000,
          minPrice: 35000,
          maxPrice: 48000,
          lastPrice: 35000,
          lastCapturedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        alert: AlertDto(
          id: 'alert-001',
          trackingId: 'track-001',
          ruleType: AlertRuleType.belowAvg,
          targetPrice: null,
          cooldownHours: 24,
          isEnabled: true,
          lastTriggeredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        isFavorite: true,
      ),
      TrackingWithProduct(
        tracking: TrackingDto(
          id: 'track-002',
          petId: 'pet-001',
          productId: 'prod-002',
          status: TrackingStatus.active,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        product: ProductDto(
          id: 'prod-002',
          brandName: '힐스',
          productName: '사이언스 다이어트 어덜트',
          sizeLabel: '5kg',
          isActive: true,
        ),
        currentPrice: 45000,
        avgPrice: 45000,
        deltaPercent: 0.0,
        isNewLow: false,
        priceSummary: PriceSummaryDto(
          offerId: 'offer-002',
          windowDays: 30,
          avgPrice: 45000,
          minPrice: 42000,
          maxPrice: 48000,
          lastPrice: 45000,
          lastCapturedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        alert: AlertDto(
          id: 'alert-002',
          trackingId: 'track-002',
          ruleType: AlertRuleType.newLow,
          targetPrice: null,
          cooldownHours: 24,
          isEnabled: false,
          lastTriggeredAt: null,
        ),
        isFavorite: false,
      ),
      TrackingWithProduct(
        tracking: TrackingDto(
          id: 'track-003',
          petId: 'pet-001',
          productId: 'prod-003',
          status: TrackingStatus.active,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        product: ProductDto(
          id: 'prod-003',
          brandName: '퍼피',
          productName: '초이스 어덜트',
          sizeLabel: '2kg',
          isActive: true,
        ),
        currentPrice: 28000,
        avgPrice: 30000,
        deltaPercent: -6.67,
        isNewLow: false,
        priceSummary: PriceSummaryDto(
          offerId: 'offer-003',
          windowDays: 30,
          avgPrice: 30000,
          minPrice: 28000,
          maxPrice: 32000,
          lastPrice: 28000,
          lastCapturedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        alert: AlertDto(
          id: 'alert-003',
          trackingId: 'track-003',
          ruleType: AlertRuleType.targetPrice,
          targetPrice: 27000,
          cooldownHours: 12,
          isEnabled: true,
          lastTriggeredAt: null,
        ),
        isFavorite: true,
      ),
      TrackingWithProduct(
        tracking: TrackingDto(
          id: 'track-004',
          petId: 'pet-001',
          productId: 'prod-004',
          status: TrackingStatus.active,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        product: ProductDto(
          id: 'prod-004',
          brandName: '네츄럴밸런스',
          productName: '리미티드 인그리디언트',
          sizeLabel: '4.5kg',
          isActive: true,
        ),
        currentPrice: 52000,
        avgPrice: 58000,
        deltaPercent: -10.34,
        isNewLow: true,
        priceSummary: PriceSummaryDto(
          offerId: 'offer-004',
          windowDays: 30,
          avgPrice: 58000,
          minPrice: 52000,
          maxPrice: 65000,
          lastPrice: 52000,
          lastCapturedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        alert: AlertDto(
          id: 'alert-004',
          trackingId: 'track-004',
          ruleType: AlertRuleType.belowAvg,
          targetPrice: null,
          cooldownHours: 24,
          isEnabled: true,
          lastTriggeredAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        isFavorite: false,
      ),
    ];
  }
}

/// 추적 정보 + 상품 정보 결합 모델
class TrackingWithProduct {
  final TrackingDto tracking;
  final ProductDto product;
  final int currentPrice;
  final int avgPrice;
  final double deltaPercent;
  final bool isNewLow;
  final PriceSummaryDto priceSummary;
  final AlertDto alert;
  final bool isFavorite;

  TrackingWithProduct({
    required this.tracking,
    required this.product,
    required this.currentPrice,
    required this.avgPrice,
    required this.deltaPercent,
    required this.isNewLow,
    required this.priceSummary,
    required this.alert,
    required this.isFavorite,
  });

  /// 가격 맥락 텍스트
  String get priceContext {
    if (deltaPercent < -10) {
      return '이 가격은 평균보다 ${deltaPercent.abs().toStringAsFixed(1)}% 저렴해요';
    } else if (deltaPercent > 5) {
      return '최근 가격 상승 중이에요';
    } else if (isNewLow) {
      return '최근 30일 최저가예요';
    } else {
      return '평균가와 비슷해요';
    }
  }
}

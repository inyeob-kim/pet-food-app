import '../models/product_dto.dart';
import '../models/price_summary_dto.dart';
import '../../core/constants/enums.dart';

/// 사료 상세 화면 더미 데이터
class ProductDetailMockData {
  /// 상세 정보
  static ProductDetailData get detail {
    return ProductDetailData(
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
      priceStableDays: 3,
      merchant: Merchant.coupang,
      // 우리 아이 기준 계산
      petWeight: 12.0, // kg
      dailyAmount: 120.0, // g
      daysSupply: 25, // 일
      // 정기배송 판단
      subscriptionPrice: 33000,
      subscriptionDiscount: 5.7,
      isSubscriptionBetter: true,
      subscriptionReason: '정기배송이 5.7% 더 저렴하고, 소진 주기를 맞춰 자동 배송돼요',
    );
  }
}

/// 상세 정보 데이터
class ProductDetailData {
  final ProductDto product;
  final int currentPrice;
  final int avgPrice;
  final double deltaPercent;
  final bool isNewLow;
  final PriceSummaryDto priceSummary;
  final int priceStableDays; // 이 가격이 유지된 일수
  final Merchant merchant;
  
  // 우리 아이 기준
  final double petWeight; // kg
  final double dailyAmount; // g
  final int daysSupply; // 일
  
  // 정기배송
  final int? subscriptionPrice;
  final double? subscriptionDiscount; // %
  final bool isSubscriptionBetter;
  final String? subscriptionReason;

  ProductDetailData({
    required this.product,
    required this.currentPrice,
    required this.avgPrice,
    required this.deltaPercent,
    required this.isNewLow,
    required this.priceSummary,
    required this.priceStableDays,
    required this.merchant,
    required this.petWeight,
    required this.dailyAmount,
    required this.daysSupply,
    this.subscriptionPrice,
    this.subscriptionDiscount,
    required this.isSubscriptionBetter,
    this.subscriptionReason,
  });

  /// 가격 설명 텍스트
  String get priceDescription {
    if (priceStableDays > 0) {
      return '이 가격은 보통 ${priceStableDays}일 유지돼요';
    }
    return '최근 가격 변동이 있어요';
  }

  /// 우리 아이 기준 설명
  String get petBasedDescription {
    return '${petWeight}kg, 하루 ${dailyAmount.toInt()}g 기준\n약 ${daysSupply}일 급여 가능';
  }
}

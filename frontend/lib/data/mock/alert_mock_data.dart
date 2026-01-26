import '../models/product_dto.dart';

/// 알림 화면 더미 데이터
class AlertMockData {
  /// 가격 하락 알림 리스트
  static List<AlertItem> get priceDropAlerts {
    return [
      AlertItem(
        id: 'alert-001',
        type: AlertType.priceDrop,
        product: ProductDto(
          id: 'prod-001',
          brandName: '로얄캐닌',
          productName: '미니 어덜트 강아지 사료',
          sizeLabel: '3kg',
          isActive: true,
        ),
        message: '가격이 16.7% 하락했어요',
        currentPrice: 35000,
        previousPrice: 42000,
        deltaPercent: -16.67,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AlertItem(
        id: 'alert-002',
        type: AlertType.priceDrop,
        product: ProductDto(
          id: 'prod-004',
          brandName: '네츄럴밸런스',
          productName: '리미티드 인그리디언트',
          sizeLabel: '4.5kg',
          isActive: true,
        ),
        message: '가격이 10.3% 하락했어요',
        currentPrice: 52000,
        previousPrice: 58000,
        deltaPercent: -10.34,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
    ];
  }

  /// 소진 임박 알림 리스트
  static List<AlertItem> get lowStockAlerts {
    return [
      AlertItem(
        id: 'alert-003',
        type: AlertType.lowStock,
        product: ProductDto(
          id: 'prod-001',
          brandName: '로얄캐닌',
          productName: '미니 어덜트 강아지 사료',
          sizeLabel: '3kg',
          isActive: true,
        ),
        message: '소진까지 약 5일 남았어요',
        currentPrice: 35000,
        previousPrice: null,
        deltaPercent: null,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        daysUntilEmpty: 5,
      ),
    ];
  }

  /// 모든 알림 (가격 + 소진)
  static List<AlertItem> get allAlerts {
    return [...priceDropAlerts, ...lowStockAlerts]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}

/// 알림 타입
enum AlertType {
  priceDrop,
  lowStock,
  newLow,
}

/// 알림 아이템
class AlertItem {
  final String id;
  final AlertType type;
  final ProductDto product;
  final String message;
  final int currentPrice;
  final int? previousPrice;
  final double? deltaPercent;
  final DateTime timestamp;
  final bool isRead;
  final int? daysUntilEmpty;

  AlertItem({
    required this.id,
    required this.type,
    required this.product,
    required this.message,
    required this.currentPrice,
    this.previousPrice,
    this.deltaPercent,
    required this.timestamp,
    this.isRead = false,
    this.daysUntilEmpty,
  });
}

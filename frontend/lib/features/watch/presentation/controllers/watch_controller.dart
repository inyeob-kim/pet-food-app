import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/tracking_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_handler.dart';

/// 추적 상품 데이터 모델
class TrackingProductData {
  final String id;
  final String title;
  final String brandName;
  final String price;
  final int? priceValue; // 숫자 가격 (정렬용)
  final int? avgPrice; // 평균 가격
  final double? deltaPercent; // 평균 대비 퍼센트
  final bool isNewLow; // 최저가 여부
  final List<String> reasons;
  final bool isAlertOn;

  TrackingProductData({
    required this.id,
    required this.title,
    required this.brandName,
    required this.price,
    this.priceValue,
    this.avgPrice,
    this.deltaPercent,
    this.isNewLow = false,
    required this.reasons,
    this.isAlertOn = false,
  });
}

/// 정렬 옵션
enum SortOption {
  priceLow, // 저렴한 순
  priceStable, // 가격 변동 낮은 순
  popular, // 인기순
}

/// 관심 화면 상태
class WatchState {
  final bool isLoading;
  final String? error;
  final List<TrackingProductData> trackingProducts;
  final SortOption sortOption;

  const WatchState({
    this.isLoading = false,
    this.error,
    this.trackingProducts = const [],
    this.sortOption = SortOption.priceLow,
  });

  WatchState copyWith({
    bool? isLoading,
    String? error,
    List<TrackingProductData>? trackingProducts,
    SortOption? sortOption,
  }) {
    return WatchState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      trackingProducts: trackingProducts ?? this.trackingProducts,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  /// 정렬된 상품 목록
  List<TrackingProductData> get sortedProducts {
    final products = List<TrackingProductData>.from(trackingProducts);
    final currentSort = sortOption ?? SortOption.priceLow; // null safety fallback
    switch (currentSort) {
      case SortOption.priceLow:
        products.sort((a, b) {
          final aPrice = a.priceValue ?? 0;
          final bPrice = b.priceValue ?? 0;
          return aPrice.compareTo(bPrice);
        });
        break;
      case SortOption.priceStable:
        // 가격 변동 낮은 순 (deltaPercent 절댓값이 작은 순)
        products.sort((a, b) {
          final aDelta = a.deltaPercent?.abs() ?? 999;
          final bDelta = b.deltaPercent?.abs() ?? 999;
          return aDelta.compareTo(bDelta);
        });
        break;
      case SortOption.popular:
        // 인기순 (임시로 알림 켜진 순)
        products.sort((a, b) => b.isAlertOn ? 1 : (a.isAlertOn ? -1 : 0));
        break;
    }
    return products;
  }

  /// 평균보다 저렴한 상품 개수
  int get cheaperCount {
    return trackingProducts.where((p) {
      return p.deltaPercent != null && p.deltaPercent! < 0;
    }).length;
  }
}

/// 관심 화면 컨트롤러
class WatchController extends StateNotifier<WatchState> {
  // TODO: API 호출 시 사용
  // final TrackingRepository _trackingRepository;

  WatchController(TrackingRepository trackingRepository) : super(WatchState()) {
    loadTrackingProducts();
  }

  /// 추적 상품 목록 로드 (public으로 변경하여 재시도 가능하게)
  Future<void> loadTrackingProducts() async {
    state = state.copyWith(isLoading: true);
    
    // TODO: 실제 API 호출로 변경
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = state.copyWith(
      isLoading: false,
      trackingProducts: _generateMockTrackingProducts(),
    );
  }

  /// 정렬 옵션 변경
  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  /// 알림 토글
  Future<void> toggleAlert(String productId, bool isOn) async {
    try {
      // TODO: 실제 API 호출로 알림 설정 업데이트
      await Future.delayed(const Duration(milliseconds: 300));
      
      // 상태 업데이트
      final updatedProducts = state.trackingProducts.map((product) {
        if (product.id == productId) {
          return TrackingProductData(
            id: product.id,
            title: product.title,
            brandName: product.brandName,
            price: product.price,
            reasons: product.reasons,
            isAlertOn: isOn,
          );
        }
        return product;
      }).toList();
      
      state = state.copyWith(trackingProducts: updatedProducts);
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('알림 설정 업데이트 실패: ${e.toString()}');
      state = state.copyWith(error: failure.message);
    }
  }

  // 임시 데이터 생성 (나중에 API 호출로 대체)
  List<TrackingProductData> _generateMockTrackingProducts() {
    return [
      TrackingProductData(
        id: 'tracking_1',
        title: '로얄캐닌 미니 어덜트',
        brandName: '로얄캐닌',
        price: '45,000원',
        priceValue: 45000,
        avgPrice: 50000,
        deltaPercent: -10.0,
        isNewLow: false,
        reasons: ['장 건강 케어', '평균가 대비 안정적'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_2',
        title: '힐스 프리미엄 케어',
        brandName: '힐스',
        price: '52,000원',
        priceValue: 52000,
        avgPrice: 55000,
        deltaPercent: -5.5,
        isNewLow: false,
        reasons: ['피부 건강 케어', '최근 14일 평균 대비 할인'],
        isAlertOn: false,
      ),
      TrackingProductData(
        id: 'tracking_3',
        title: '퍼피 초이스',
        brandName: '퍼피',
        price: '38,000원',
        priceValue: 38000,
        avgPrice: 40000,
        deltaPercent: -5.0,
        isNewLow: true,
        reasons: ['알레르기 제외', '가성비 우수'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_4',
        title: '뉴트리나 건강백서',
        brandName: '뉴트리나',
        price: '29,000원',
        priceValue: 29000,
        avgPrice: 35000,
        deltaPercent: -17.1,
        isNewLow: false,
        reasons: ['관절 건강', '가성비 최고'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_5',
        title: 'ANF 6 Free',
        brandName: 'ANF',
        price: '60,000원',
        priceValue: 60000,
        avgPrice: 58000,
        deltaPercent: 3.4,
        isNewLow: false,
        reasons: ['알러지 케어', '프리미엄'],
        isAlertOn: false,
      ),
      TrackingProductData(
        id: 'tracking_6',
        title: '퓨리나 프로플랜',
        brandName: '퓨리나',
        price: '40,000원',
        priceValue: 40000,
        avgPrice: 42000,
        deltaPercent: -4.8,
        isNewLow: false,
        reasons: ['소화기 건강', '활동량 많음'],
        isAlertOn: true,
      ),
    ];
  }
}

final watchControllerProvider =
    StateNotifierProvider<WatchController, WatchState>((ref) {
  final trackingRepository = ref.watch(trackingRepositoryProvider);
  return WatchController(trackingRepository);
});

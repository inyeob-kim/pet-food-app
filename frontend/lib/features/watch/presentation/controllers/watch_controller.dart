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
  final List<String> reasons;
  final bool isAlertOn;

  TrackingProductData({
    required this.id,
    required this.title,
    required this.brandName,
    required this.price,
    required this.reasons,
    this.isAlertOn = false,
  });
}

/// 관심 화면 상태
class WatchState {
  final bool isLoading;
  final String? error;
  final List<TrackingProductData> trackingProducts;

  WatchState({
    this.isLoading = false,
    this.error,
    this.trackingProducts = const [],
  });

  WatchState copyWith({
    bool? isLoading,
    String? error,
    List<TrackingProductData>? trackingProducts,
  }) {
    return WatchState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      trackingProducts: trackingProducts ?? this.trackingProducts,
    );
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
        reasons: ['장 건강 케어', '평균가 대비 안정적'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_2',
        title: '힐스 프리미엄 케어',
        brandName: '힐스',
        price: '52,000원',
        reasons: ['피부 건강 케어', '최근 14일 평균 대비 할인'],
        isAlertOn: false,
      ),
      TrackingProductData(
        id: 'tracking_3',
        title: '퍼피 초이스',
        brandName: '퍼피',
        price: '38,000원',
        reasons: ['알레르기 제외', '가성비 우수'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_4',
        title: '뉴트리나 건강백서',
        brandName: '뉴트리나',
        price: '29,000원',
        reasons: ['관절 건강', '가성비 최고'],
        isAlertOn: true,
      ),
      TrackingProductData(
        id: 'tracking_5',
        title: 'ANF 6 Free',
        brandName: 'ANF',
        price: '60,000원',
        reasons: ['알러지 케어', '프리미엄'],
        isAlertOn: false,
      ),
      TrackingProductData(
        id: 'tracking_6',
        title: '퓨리나 프로플랜',
        brandName: '퓨리나',
        price: '40,000원',
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

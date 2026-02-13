import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/tracking_repository.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/models/tracking_dto.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_handler.dart';

/// 추적 상품 데이터 모델
class TrackingProductData {
  final String id; // tracking ID
  final String productId; // 상품 ID
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
    required this.productId,
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
  final Set<String> trackedProductIds; // 찜한 상품 ID 목록

  const WatchState({
    this.isLoading = false,
    this.error,
    this.trackingProducts = const [],
    this.sortOption = SortOption.priceLow,
    this.trackedProductIds = const {},
  });

  WatchState copyWith({
    bool? isLoading,
    String? error,
    List<TrackingProductData>? trackingProducts,
    SortOption? sortOption,
    Set<String>? trackedProductIds,
  }) {
    return WatchState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      trackingProducts: trackingProducts ?? this.trackingProducts,
      sortOption: sortOption ?? this.sortOption,
      trackedProductIds: trackedProductIds ?? this.trackedProductIds,
    );
  }

  /// 정렬된 상품 목록
  List<TrackingProductData> get sortedProducts {
    final products = List<TrackingProductData>.from(trackingProducts);
    final currentSort = sortOption;
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
/// 단일 책임: 추적 상품 목록 관리
class WatchController extends StateNotifier<WatchState> {
  final TrackingRepository _trackingRepository;
  final ProductRepository _productRepository;

  WatchController(
    TrackingRepository trackingRepository,
    ProductRepository productRepository,
  ) : _trackingRepository = trackingRepository,
      _productRepository = productRepository,
      super(WatchState()) {
    loadTrackingProducts();
  }

  /// 추적 상품 목록 로드
  Future<void> loadTrackingProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 추적 목록 조회
      final trackings = await _trackingRepository.getTrackings();
      
      // 빈 배열인 경우 즉시 반환
      if (trackings.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          trackingProducts: [],
        );
        return;
      }
      
      // 각 추적에 대한 상품 정보 조회 및 변환
      final trackingProducts = await Future.wait(
        trackings.map((tracking) => _convertToTrackingProductData(tracking)),
      );
      
      // Future.wait로 이미 모든 값이 non-null이므로 필터링 불필요
      final validProducts = trackingProducts.cast<TrackingProductData>().toList();
      
      // 찜한 상품 ID 목록 업데이트 (productId 기준)
      final trackedIds = validProducts.map((p) => p.productId).toSet();
      
      state = state.copyWith(
        isLoading: false,
        trackingProducts: validProducts,
        trackedProductIds: trackedIds,
      );
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('추적 상품을 불러오는데 실패했습니다: ${e.toString()}');
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
        trackingProducts: [],
      );
    }
  }

  /// TrackingDto를 TrackingProductData로 변환
  Future<TrackingProductData> _convertToTrackingProductData(TrackingDto tracking) async {
    try {
      // tracking이 null이거나 productId가 없는 경우
      if (tracking.productId.isEmpty) {
        return TrackingProductData(
          id: tracking.id,
          productId: tracking.productId,
          title: '상품 정보 없음',
          brandName: '알 수 없음',
          price: '가격 정보 없음',
          priceValue: null,
          avgPrice: null,
          deltaPercent: null,
          isNewLow: false,
          reasons: ['상품 ID가 없습니다'],
          isAlertOn: false,
        );
      }
      
      // 상품 정보 조회
      final product = await _productRepository.getProduct(tracking.productId);
      
      // 임시 데이터 (백엔드 API 확장 시 실제 데이터로 대체)
      return TrackingProductData(
        id: tracking.id,
        productId: tracking.productId,
        title: '${product.brandName} ${product.productName}',
        brandName: product.brandName,
        price: '가격 정보 없음', // TODO: ProductOffer에서 가격 정보 가져오기
        priceValue: null,
        avgPrice: null,
        deltaPercent: null,
        isNewLow: false,
        reasons: ['추적 중인 상품'],
        isAlertOn: tracking.status == TrackingStatus.active,
      );
    } catch (e) {
      // 상품 조회 실패 시 기본 데이터 반환
      return TrackingProductData(
        id: tracking.id,
        productId: tracking.productId,
        title: '상품 정보 없음',
        brandName: '알 수 없음',
        price: '가격 정보 없음',
        priceValue: null,
        avgPrice: null,
        deltaPercent: null,
        isNewLow: false,
        reasons: ['상품 정보를 불러올 수 없습니다'],
        isAlertOn: false,
      );
    }
  }

  /// 정렬 옵션 변경
  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  /// 알림 토글
  Future<void> toggleAlert(String trackingId, bool isOn) async {
    try {
      // TODO: 백엔드에 알림 설정 API 추가 시 구현
      // 현재는 로컬 상태만 업데이트
      final updatedProducts = state.trackingProducts.map((product) {
        if (product.id == trackingId) {
          return TrackingProductData(
            id: product.id,
            productId: product.productId,
            title: product.title,
            brandName: product.brandName,
            price: product.price,
            priceValue: product.priceValue,
            avgPrice: product.avgPrice,
            deltaPercent: product.deltaPercent,
            isNewLow: product.isNewLow,
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

  /// 찜한 상품인지 확인
  bool isProductTracked(String productId) {
    return state.trackedProductIds.contains(productId);
  }

  /// 찜 추가
  Future<bool> addTracking(String productId, String petId) async {
    try {
      await _trackingRepository.createTracking(
        productId: productId,
        petId: petId,
      );
      
      // 찜한 상품 목록 새로고침
      await loadTrackingProducts();
      
      return true;
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('찜 추가 실패: ${e.toString()}');
      state = state.copyWith(error: failure.message);
      return false;
    }
  }

  /// 찜 취소
  Future<bool> removeTracking(String productId) async {
    try {
      // trackingProducts에서 해당 productId를 가진 tracking 찾기
      final tracking = state.trackingProducts.firstWhere(
        (product) => product.productId == productId,
        orElse: () => throw Exception('찜한 상품을 찾을 수 없습니다'),
      );
      
      await _trackingRepository.deleteTracking(tracking.id);
      
      // 찜한 상품 목록 새로고침
      await loadTrackingProducts();
      
      return true;
    } catch (e) {
      final failure = e is Exception
          ? handleException(e)
          : ServerFailure('찜 취소 실패: ${e.toString()}');
      state = state.copyWith(error: failure.message);
      return false;
    }
  }

  /// productId로 tracking 찾기
  String? findTrackingIdByProductId(String productId) {
    try {
      final tracking = state.trackingProducts.firstWhere(
        (product) => product.productId == productId,
      );
      return tracking.id;
    } catch (e) {
      return null;
    }
  }
}

final watchControllerProvider =
    StateNotifierProvider<WatchController, WatchState>((ref) {
  final trackingRepository = ref.watch(trackingRepositoryProvider);
  final productRepository = ref.watch(productRepositoryProvider);
  return WatchController(trackingRepository, productRepository);
});

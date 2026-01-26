import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/product_repository.dart';
import '../../../../data/repositories/tracking_repository.dart';
import '../../../../data/models/product_dto.dart';
import '../../../../core/error/failures.dart';

class ProductDetailState {
  final ProductDto? product;
  final bool isLoading;
  final bool isTrackingLoading;
  final String? error;
  final bool trackingCreated;

  ProductDetailState({
    this.product,
    this.isLoading = false,
    this.isTrackingLoading = false,
    this.error,
    this.trackingCreated = false,
  });

  ProductDetailState copyWith({
    ProductDto? product,
    bool? isLoading,
    bool? isTrackingLoading,
    String? error,
    bool? trackingCreated,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isTrackingLoading: isTrackingLoading ?? this.isTrackingLoading,
      error: error ?? this.error,
      trackingCreated: trackingCreated ?? this.trackingCreated,
    );
  }
}

class ProductDetailController extends StateNotifier<ProductDetailState> {
  final ProductRepository _productRepository;
  final TrackingRepository _trackingRepository;

  ProductDetailController(
    this._productRepository,
    this._trackingRepository,
  ) : super(ProductDetailState());

  Future<void> loadProduct(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final product = await _productRepository.getProduct(productId);
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      Failure failure;
      if (e is Exception) {
        failure = handleException(e);
      } else {
        failure = ServerFailure('알 수 없는 오류가 발생했습니다: ${e.toString()}');
      }
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
      );
    }
  }

  Future<void> createTracking(String productId, String petId) async {
    state = state.copyWith(isTrackingLoading: true, error: null);

    try {
      await _trackingRepository.createTracking(
        productId: productId,
        petId: petId,
      );
      state = state.copyWith(
        isTrackingLoading: false,
        trackingCreated: true,
      );
    } catch (e) {
      final failure = handleException(e as Exception);
      state = state.copyWith(
        isTrackingLoading: false,
        error: failure.message,
      );
    }
  }
}

final productDetailControllerProvider =
    StateNotifierProvider.family<ProductDetailController, ProductDetailState, String>(
  (ref, productId) {
    final productRepository = ref.watch(productRepositoryProvider);
    final trackingRepository = ref.watch(trackingRepositoryProvider);
    return ProductDetailController(productRepository, trackingRepository);
  },
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/models/product_dto.dart';
import '../widgets/category_chips.dart';
import '../../../watch/presentation/controllers/watch_controller.dart';

/// 마켓 화면 상태
class MarketState {
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final List<ProductDto> hotDealProducts;
  final List<ProductDto> popularProducts;
  final List<ProductDto> allProducts;
  final List<CategoryChipData> categories;
  final String? selectedCategoryId;
  final String? searchQuery;
  final Set<String> trackedProductIds; // 찜한 상품 ID 목록

  MarketState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.hotDealProducts = const [],
    this.popularProducts = const [],
    this.allProducts = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchQuery,
    this.trackedProductIds = const {},
  });

  MarketState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    List<ProductDto>? hotDealProducts,
    List<ProductDto>? popularProducts,
    List<ProductDto>? allProducts,
    List<CategoryChipData>? categories,
    String? selectedCategoryId,
    String? searchQuery,
    Set<String>? trackedProductIds,
  }) {
    return MarketState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      hotDealProducts: hotDealProducts ?? this.hotDealProducts,
      popularProducts: popularProducts ?? this.popularProducts,
      allProducts: allProducts ?? this.allProducts,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      trackedProductIds: trackedProductIds ?? this.trackedProductIds,
    );
  }
}

/// 마켓 화면 컨트롤러
/// 단일 책임: 상품 목록 관리
class MarketController extends StateNotifier<MarketState> {
  final ProductRepository _productRepository;
  final Ref _ref;

  MarketController(ProductRepository productRepository, Ref ref)
      : _productRepository = productRepository,
        _ref = ref,
        super(MarketState()) {
    _initialize();
  }

  /// 초기화
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final products = await _productRepository.getProducts();
      // WatchController에서 찜한 상품 ID 목록 가져오기
      final watchState = _ref.read(watchControllerProvider);
      final trackedIds = watchState.trackedProductIds;
      
      state = state.copyWith(
        isLoading: false,
        allProducts: products,
        hotDealProducts: products.take(5).toList(), // 임시: 상위 5개
        popularProducts: products.take(5).toList(), // 임시: 상위 5개
        categories: _generateCategories(),
        trackedProductIds: trackedIds,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '상품 목록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    
    try {
      final products = await _productRepository.getProducts();
      // WatchController에서 찜한 상품 ID 목록 가져오기
      final watchState = _ref.read(watchControllerProvider);
      final trackedIds = watchState.trackedProductIds;
      
      state = state.copyWith(
        isRefreshing: false,
        allProducts: products,
        hotDealProducts: products.take(5).toList(),
        popularProducts: products.take(5).toList(),
        trackedProductIds: trackedIds,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: '상품 목록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 찜 상태 업데이트 (WatchController 변경 시 호출)
  void updateTrackingStatus() {
    final watchState = _ref.read(watchControllerProvider);
    final trackedIds = watchState.trackedProductIds;
    
    // trackedProductIds만 업데이트 (불필요한 리스트 재생성 제거)
    state = state.copyWith(
      trackedProductIds: trackedIds,
    );
  }


  /// 카테고리 선택
  void selectCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
    // TODO: 백엔드에 카테고리 필터 API 추가 시 구현
  }

  /// 검색 쿼리 설정
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    // TODO: 백엔드에 검색 API 추가 시 구현
  }

  List<CategoryChipData> _generateCategories() {
    return [
      CategoryChipData(id: 'all', label: '전체'),
      CategoryChipData(id: 'dog', label: '강아지', icon: Icons.pets),
      CategoryChipData(id: 'cat', label: '고양이', icon: Icons.pets),
      CategoryChipData(id: 'puppy', label: '퍼피'),
      CategoryChipData(id: 'adult', label: '어덜트'),
      CategoryChipData(id: 'senior', label: '시니어'),
    ];
  }
}

final marketControllerProvider =
    StateNotifierProvider<MarketController, MarketState>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return MarketController(productRepository, ref);
});

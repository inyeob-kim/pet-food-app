import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/product_repository.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chips.dart';

/// 마켓 화면 상태
class MarketState {
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final List<ProductCardData> hotDealProducts;
  final List<ProductCardData> popularProducts;
  final List<ProductCardData> allProducts;
  final List<CategoryChipData> categories;
  final String? selectedCategoryId;
  final String? searchQuery;

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
  });

  MarketState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    List<ProductCardData>? hotDealProducts,
    List<ProductCardData>? popularProducts,
    List<ProductCardData>? allProducts,
    List<CategoryChipData>? categories,
    String? selectedCategoryId,
    String? searchQuery,
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
    );
  }
}

/// 마켓 화면 컨트롤러
class MarketController extends StateNotifier<MarketState> {
  // TODO: API 호출 시 사용
  // final ProductRepository _productRepository;

  MarketController(ProductRepository productRepository) : super(MarketState()) {
    _initialize();
  }

  /// 초기화 (임시 데이터 로드)
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    // TODO: 실제 API 호출로 변경
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = state.copyWith(
      isLoading: false,
      hotDealProducts: _generateHotDealProducts(),
      popularProducts: _generatePopularProducts(),
      allProducts: _generateAllProducts(),
      categories: _generateCategories(),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    
    // TODO: 실제 API 호출로 변경
    await Future.delayed(const Duration(milliseconds: 800));
    
    state = state.copyWith(
      isRefreshing: false,
      hotDealProducts: _generateHotDealProducts(),
      popularProducts: _generatePopularProducts(),
      allProducts: _generateAllProducts(),
    );
  }

  /// 카테고리 선택
  void selectCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
    // TODO: 카테고리 필터 적용
  }

  /// 검색 쿼리 설정
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    // TODO: 검색 API 호출
  }

  // 임시 데이터 생성 메서드들 (나중에 API 호출로 대체)
  List<ProductCardData> _generateHotDealProducts() {
    return List.generate(5, (index) {
      return ProductCardData(
        id: 'hotdeal_$index',
        brandName: '로얄캐닌',
        productName: '로얄캐닌 미니 어덜트 ${index + 1}',
        price: 35000 - (index * 2000),
        originalPrice: 40000,
        discountRate: (index + 1) * 5.0,
      );
    });
  }

  List<ProductCardData> _generatePopularProducts() {
    return List.generate(5, (index) {
      return ProductCardData(
        id: 'popular_$index',
        brandName: ['힐스', '오리젠', '아카나', '네츄럴밸런스', '퍼피'][index],
        productName: '${['힐스', '오리젠', '아카나', '네츄럴밸런스', '퍼피'][index]} 사료 ${index + 1}',
        price: 30000 + (index * 5000),
      );
    });
  }

  List<ProductCardData> _generateAllProducts() {
    return List.generate(20, (index) {
      return ProductCardData(
        id: 'product_$index',
        brandName: ['로얄캐닌', '힐스', '오리젠', '아카나'][index % 4],
        productName: '${['로얄캐닌', '힐스', '오리젠', '아카나'][index % 4]} 사료 제품 ${index + 1}',
        price: 25000 + (index * 1000),
        discountRate: index % 3 == 0 ? 10.0 : null,
      );
    });
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
  return MarketController(productRepository);
});

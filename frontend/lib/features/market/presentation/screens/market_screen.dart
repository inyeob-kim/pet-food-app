import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../ui/icons/app_icons.dart';
import '../../../../../core/widgets/state_handler.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../widgets/section_header.dart';
import '../widgets/horizontal_product_list.dart';
import '../widgets/recommend_banner_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_grid_card.dart';
import '../controllers/market_controller.dart';

/// 사료 마켓 페이지 (폴센트 마켓플레이스 스타일)
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(marketControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white, // 전체 흰색 배경
      body: StateHandler(
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: state.allProducts.isEmpty && !state.isLoading,
        onRetry: () => ref.read(marketControllerProvider.notifier).refresh(),
        emptyWidget: const EmptyStateWidget(
          title: '상품이 없습니다',
          description: '새로운 상품을 추가해보세요',
        ),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            title: Text(
              '사료마켓',
              style: AppTypography.h2.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            actions: [
              IconButton(
                icon: AppIcons.bell(),
                onPressed: () {
                  // TODO: 알림 페이지로 이동
                },
              ),
              IconButton(
                icon: AppIcons.settings(),
                onPressed: () {
                  // TODO: 설정 페이지로 이동
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 검색 바
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: _buildSearchBar(),
            ),
          ),

          // 섹션1: 오늘의 핫딜
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: '오늘의 핫딜',
                  subtitle: '지금 가장 저렴한 사료',
                  onTapMore: () {
                    // TODO: 핫딜 더보기
                  },
                ),
                const SizedBox(height: 16),
                HorizontalProductList(
                  products: state.hotDealProducts,
                  onProductTap: (productId) {
                    context.push(RoutePaths.productDetailPath(productId));
                  },
                ),
                const SizedBox(height: 20),
                // 섹션 구분선
                Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // 섹션2: 실시간 인기 사료
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: '실시간 인기 사료',
                  subtitle: '지금 많이 찾는 사료',
                  onTapMore: () {
                    // TODO: 인기 사료 더보기
                  },
                ),
                const SizedBox(height: 16),
                HorizontalProductList(
                  products: state.popularProducts,
                  onProductTap: (productId) {
                    context.push(RoutePaths.productDetailPath(productId));
                  },
                ),
                const SizedBox(height: 20),
                // 섹션 구분선
                Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // 섹션3: 맞춤 추천
          SliverToBoxAdapter(
            child: Column(
              children: [
                const RecommendBannerCard(),
                const SizedBox(height: 20),
                // 섹션 구분선
                Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // 섹션4: 카테고리 칩
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: '카테고리',
                ),
                const SizedBox(height: 16),
                         CategoryChips(
                           categories: state.categories,
                           selectedCategoryId: state.selectedCategoryId,
                           onCategoryTap: (categoryId) {
                             ref.read(marketControllerProvider.notifier).selectCategory(
                                   categoryId == 'all' ? null : categoryId,
                                 );
                           },
                         ),
                const SizedBox(height: 20),
                // 섹션 구분선
                Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // 섹션5: 전체 사료
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                         SectionHeader(
                           title: '전체 사료',
                           subtitle: '${state.allProducts.length}개 상품',
                         ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 전체 사료 그리드
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72, // overflow 방지를 위해 약간 줄임
                crossAxisSpacing: AppSpacing.gridGap,
                mainAxisSpacing: AppSpacing.gridGap,
              ),
                       delegate: SliverChildBuilderDelegate(
                         (context, index) {
                           return ProductGridCard(
                             data: state.allProducts[index],
                             onTap: () {
                               context.push(RoutePaths.productDetailPath(state.allProducts[index].id));
                             },
                           );
                         },
                         childCount: state.allProducts.length,
                       ),
            ),
          ),

          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final state = ref.watch(marketControllerProvider);
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '사료 브랜드나 제품명을 검색하세요',
          hintStyle: AppTypography.body2.copyWith(
            color: Colors.grey.shade500,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: state.searchQuery != null && state.searchQuery!.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade500),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(marketControllerProvider.notifier).setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          ref.read(marketControllerProvider.notifier).setSearchQuery(value);
        },
        onSubmitted: (value) {
          // TODO: 검색 실행
        },
      ),
    );
  }
}

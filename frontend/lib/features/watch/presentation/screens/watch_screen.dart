import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/app_scaffold.dart';
import '../../../../../ui/theme/app_typography.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../core/widgets/state_handler.dart';
import '../../../../../ui/components/product_tile.dart';
import '../controllers/watch_controller.dart';

/// 찜한 사료 화면 (토스 스타일 - 구매 판단 대기열)
class WatchScreen extends ConsumerWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(watchControllerProvider);
    // Null safety: ensure sortOption is never null
    final currentSort = state.sortOption;
    final sortedProducts = state.sortedProducts;
    final cheaperCount = state.cheaperCount;

    return AppScaffold(
      appBar: AppBar(
        title: Text('찜한 사료', style: AppTypography.title),
        elevation: 0,
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
      ),
      backgroundColor: AppColors.bg,
      body: StateHandler(
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: state.trackingProducts.isEmpty && !state.isLoading,
        onRetry: () => ref.read(watchControllerProvider.notifier).loadTrackingProducts(),
        emptyWidget: _buildEmptyState(context),
        child: CustomScrollView(
          slivers: [
            // 상단 요약 영역 (카드 없이)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "찜한 사료 {n}개"
                    Text(
                      '찜한 사료 ${state.trackingProducts.length}개',
                      style: AppTypography.title,
                    ),
                    if (cheaperCount > 0) ...[
                      const SizedBox(height: 8),
                      // "지금 평균보다 저렴한 사료 {k}개 있어요"
                      Text(
                        '지금 평균보다 저렴한 사료 $cheaperCount개 있어요',
                        style: AppTypography.sub.copyWith(
                          color: AppColors.positive,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 정렬/필터 칩
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSortChips(context, ref, currentSort),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 그리드 (ProductTile 사용)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 24,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = sortedProducts[index];
                    return _buildProductTile(context, product);
                  },
                  childCount: sortedProducts.length,
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
    );
  }

  Widget _buildSortChips(BuildContext context, WidgetRef ref, SortOption currentSort) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _SortChip(
            label: '저렴한 순',
            isSelected: currentSort == SortOption.priceLow,
            onTap: () {
              ref.read(watchControllerProvider.notifier).setSortOption(SortOption.priceLow);
            },
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '가격 변동 낮은 순',
            isSelected: currentSort == SortOption.priceStable,
            onTap: () {
              ref.read(watchControllerProvider.notifier).setSortOption(SortOption.priceStable);
            },
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '인기순',
            isSelected: currentSort == SortOption.popular,
            onTap: () {
              ref.read(watchControllerProvider.notifier).setSortOption(SortOption.popular);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, TrackingProductData product) {
    // 가격 파싱 (문자열에서 숫자 추출)
    final priceValue = product.priceValue ?? 0;
    
    final tileData = ProductTileData(
      id: product.id,
      brandName: product.brandName,
      productName: product.title,
      imageUrl: null,
      price: priceValue,
      discountRate: null,
      statusText: _getStatusText(product),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductTile(
          data: tileData,
          onTap: () {
            context.push(RoutePaths.productDetailPath(product.id));
          },
        ),
        // 상태 라벨 1줄 추가
        if (product.deltaPercent != null || product.isNewLow) ...[
          const SizedBox(height: 6),
          _buildStatusLabel(product),
        ],
      ],
    );
  }

  String? _getStatusText(TrackingProductData product) {
    if (product.isNewLow) {
      return '최저가 근처';
    }
    return null;
  }

  Widget _buildStatusLabel(TrackingProductData product) {
    if (product.deltaPercent != null && product.avgPrice != null) {
      final isCheaper = product.deltaPercent! < 0;
      return Text(
        '평균 대비 ${product.deltaPercent!.toStringAsFixed(1)}%',
        style: AppTypography.sub.copyWith(
          fontSize: 12,
          color: isCheaper ? AppColors.positive : AppColors.textSub,
        ),
      );
    } else if (product.isNewLow) {
      return Text(
        '최저가 근처',
        style: AppTypography.sub.copyWith(
          fontSize: 12,
          color: AppColors.positive,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.textSub.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              '아직 찜한 사료가 없어요',
              style: AppTypography.title,
            ),
            const SizedBox(height: 8),
            Text(
              '사료를 찜하고 가격 알림을 받아보세요',
              style: AppTypography.sub,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: 핫딜 화면으로 이동
                context.push(RoutePaths.market);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                '핫딜 보러가기',
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 정렬 칩 위젯
class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.sub.copyWith(
            color: isSelected ? Colors.white : AppColors.textSub,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final String productId;
  final String title;
  final String brandName;
  final String price;

  const _TrackingCard({
    required this.productId,
    required this.title,
    required this.brandName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(RoutePaths.productDetailPath(productId));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지 (사료 마켓 스타일 - 위에 배치)
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.grey.shade100,
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          // 텍스트 영역 (Padding top 8)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 브랜드명 (회색 12)
                Text(
                  brandName,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // 제품명 (14 semibold 2줄)
                Text(
                  title,
                  style: AppTypography.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.15, // 줄 간격 줄임
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                // 가격 (검정 bold)
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 15, // 폰트 크기 약간 줄임
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

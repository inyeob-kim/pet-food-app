import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../ui/widgets/app_header.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/state_handler.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/providers/pet_id_provider.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_hero_section.dart';
import '../widgets/price_graph_section.dart';
import '../widgets/alert_cta_section.dart';
import '../widgets/ingredient_analysis_section.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailControllerProvider(widget.productId).notifier).loadProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailControllerProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      appBar: AppHeader(
        title: '상품 상세',
        showNotification: false,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          _buildBody(context, state),
          // 하단 고정 탭
          if (state.product != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ProductDetailBottomBar(
                isFavorite: state.isFavorite,
                lowestPrice: state.minPrice,
                purchaseUrl: state.purchaseUrl,
                onFavoriteTap: () {
                  ref.read(productDetailControllerProvider(widget.productId).notifier).toggleFavorite();
                },
                onPurchaseTap: () {
                  // 구매 링크로 이동
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailState state) {
    return StateHandler(
      isLoading: state.isLoading,
      error: state.error,
      isEmpty: state.product == null && !state.isLoading && state.error == null,
      onRetry: () {
        ref.read(productDetailControllerProvider(widget.productId).notifier).loadProduct(widget.productId);
      },
      emptyWidget: const EmptyStateWidget(
        title: '상품 정보를 불러올 수 없습니다',
        description: '잠시 후 다시 시도해주세요',
      ),
      child: Builder(
        builder: (context) {
          final product = state.product!;
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.pagePaddingHorizontal,
              right: AppSpacing.pagePaddingHorizontal,
              top: AppSpacing.pagePaddingHorizontal,
              bottom: 120, // 하단 고정 탭 공간 확보 (SafeArea 포함)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero 영역
                ProductHeroSection(
                  productName: product.productName,
                  brandName: product.brandName,
                  sizeLabel: product.sizeLabel,
            imageUrl: null, // TODO: 실제 이미지 URL
            currentPrice: state.currentPrice,
            averagePrice: state.averagePrice,
            isGoodPrice: state.currentPrice != null && 
                        state.averagePrice != null && 
                        state.currentPrice! < state.averagePrice!,
          ),
          const SizedBox(height: 32),
          
          // 가격 변동 그래프 섹션
          PriceGraphSection(
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
            averagePrice: state.averagePrice,
            priceHistory: null, // TODO: 실제 가격 히스토리 데이터
          ),
          const SizedBox(height: 24),
          
          // 알림 받기 CTA 섹션
          AlertCtaSection(
            isTrackingCreated: state.trackingCreated,
            isTrackingLoading: state.isTrackingLoading,
            onAlertTap: () async {
              final petId = ref.read(currentPetIdProvider);
              if (petId == null) {
                // TODO: 에러 처리 (프로필 먼저 등록하라는 메시지)
                return;
              }
              await ref.read(productDetailControllerProvider(widget.productId).notifier).createTracking(
                    widget.productId,
                    petId,
                  );
            },
          ),
          const SizedBox(height: 32),
          
          // 성분 분석 섹션
          IngredientAnalysisSection(
            data: state.ingredientAnalysis,
          ),
          
          if (state.error != null) ...[
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: AppTypography.body.copyWith(
                color: AppColors.dangerRed,
              ),
              textAlign: TextAlign.center,
            ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

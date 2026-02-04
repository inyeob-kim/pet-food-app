import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/app_scaffold.dart';
import '../../../../../ui/widgets/app_header.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../core/widgets/state_handler.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../controllers/watch_controller.dart';

/// 관심(알림) 화면 (DESIGN_GUIDE.md 스타일)
class WatchScreen extends ConsumerWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(watchControllerProvider);

    return AppScaffold(
      appBar: const AppHeader(title: '찜한 사료'),
      backgroundColor: Colors.white,
      body: StateHandler(
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: state.trackingProducts.isEmpty && !state.isLoading,
        onRetry: () => ref.read(watchControllerProvider.notifier).loadTrackingProducts(),
        emptyWidget: const EmptyStateWidget(
          title: '찜한 사료가 없습니다',
          description: '사료를 찜하고 가격 알림을 받아보세요',
          icon: Icons.favorite_border,
        ),
        child: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65, // 카드 높이 증가 (overflow 방지)
          crossAxisSpacing: AppSpacing.gridGap,
          mainAxisSpacing: AppSpacing.gridGap,
        ),
        itemCount: state.trackingProducts.length,
        itemBuilder: (context, index) {
          final product = state.trackingProducts[index];
          return _TrackingCard(
            productId: product.id,
            title: product.title,
            brandName: product.brandName,
            price: product.price,
          );
        },
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

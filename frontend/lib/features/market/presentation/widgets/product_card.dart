import 'package:flutter/material.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../data/models/product_dto.dart';

/// 상품 카드 위젯 (가로/그리드 공통)
class ProductCard extends StatelessWidget {
  final ProductDto product;
  final bool isTracked; // 찜한 여부
  final VoidCallback? onTap;
  final VoidCallback? onHeartTap; // 하트 클릭 핸들러

  const ProductCard({
    super.key,
    required this.product,
    this.isTracked = false,
    this.onTap,
    this.onHeartTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상품 이미지 (이미지 중심 타일)
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                // 이미지 높이를 줄여서 텍스트 영역 확보
                return Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: width * 0.75, // 1:0.75 비율로 조정 (더 작게)
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildPlaceholder(), // TODO: ProductDto에 imageUrl 추가 시 사용
                      ),
                    ),
                    // 하트 아이콘 (우측 상단)
                    if (onHeartTap != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            onHeartTap?.call();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isTracked ? Icons.favorite : Icons.favorite_border,
                              color: isTracked ? AppColors.dangerRed : AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            // 텍스트 영역
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 브랜드명
                  Text(
                    product.brandName,
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // 제품명
                  Text(
                    product.productName,
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.15, // line height 줄임
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.sizeLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.sizeLabel!,
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                  // TODO: 가격 정보는 ProductOffer에서 가져와야 함 (API 확장 필요)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }

}

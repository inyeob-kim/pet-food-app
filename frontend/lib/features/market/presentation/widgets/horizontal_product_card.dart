import 'package:flutter/material.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../data/models/product_dto.dart';

/// 폴센트 스타일 가로 스크롤 상품 카드
class HorizontalProductCard extends StatefulWidget {
  final ProductDto product;
  final double width;
  final VoidCallback? onTap;

  const HorizontalProductCard({
    super.key,
    required this.product,
    this.width = 170,
    this.onTap,
  });

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<HorizontalProductCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상품 이미지 (이미지 중심 타일)
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImage(),
              ),
            ),
            // 텍스트 영역 (Padding top 10)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 브랜드명 (회색 12)
                  Text(
                    widget.product.brandName,
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // 상품명 (14 semibold 2줄)
                  Text(
                    widget.product.productName,
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2, // line height 줄임
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.product.sizeLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.product.sizeLabel!,
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

  Widget _buildImage() {
    // TODO: ProductDto에 imageUrl 추가 시 사용
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }


}

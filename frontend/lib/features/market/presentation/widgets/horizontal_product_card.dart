import 'package:flutter/material.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/price_formatter.dart';
import 'product_card.dart';

/// 폴센트 스타일 가로 스크롤 상품 카드
class HorizontalProductCard extends StatefulWidget {
  final ProductCardData data;
  final double width;
  final VoidCallback? onTap;

  const HorizontalProductCard({
    super.key,
    required this.data,
    this.width = 170,
    this.onTap,
  });

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<HorizontalProductCard> {
  bool _isImageLoading = true;
  bool _hasImageError = false;

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
                    widget.data.brandName,
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
                    widget.data.productName,
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2, // line height 줄임
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 가격 (검정 bold, 파란색 금지) + 할인율
                  _buildPriceSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.data.imageUrl == null || widget.data.imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (_isImageLoading && !_hasImageError) {
      return _buildImageSkeleton();
    }

    if (_hasImageError) {
      return _buildPlaceholder();
    }

    return Image.network(
      widget.data.imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          if (_isImageLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isImageLoading = false;
                });
              }
            });
          }
          return child;
        }
        return _buildImageSkeleton();
      },
      errorBuilder: (context, error, stackTrace) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isImageLoading = false;
              _hasImageError = true;
            });
          });
        }
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildImageSkeleton() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
          ),
        ),
      ),
    );
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

  Widget _buildPriceSection() {
    final hasDiscount = widget.data.discountRate != null && widget.data.discountRate! > 0;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          PriceFormatter.formatWithCurrency(widget.data.price),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            '-${widget.data.discountRate!.toInt()}%',
            style: TextStyle(
              color: AppColors.dangerRed,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

}

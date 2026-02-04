import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../core/utils/price_formatter.dart';

/// 상품 타일 데이터 모델
class ProductTileData {
  final String id;
  final String brandName;
  final String productName;
  final String? imageUrl;
  final int price;
  final int? originalPrice;
  final double? discountRate;
  final String? statusText; // '최저가', '할인' 등 상태 텍스트

  ProductTileData({
    required this.id,
    required this.brandName,
    required this.productName,
    this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountRate,
    this.statusText,
  });
}

/// 토스/폴센트 혼합형 상품 타일 (카드 느낌 없음)
/// 이미지 + 텍스트만으로 구성된 깔끔한 타일 UI
class ProductTile extends StatelessWidget {
  final ProductTileData data;
  final VoidCallback? onTap;

  const ProductTile({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이미지: ClipRRect radius 16, AspectRatio 1:1
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(),
            ),
          ),
          const SizedBox(height: 10),
          
          // 텍스트 영역
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 브랜드: sub(회색)
              Text(
                data.brandName,
                style: AppTypography.sub.copyWith(
                  color: AppColors.textSub,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // 상품명: body medium 2줄
              Text(
                data.productName,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500, // medium
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              
              // 가격: body bold
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    PriceFormatter.formatWithCurrency(data.price),
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // 할인율/상태는 작은 텍스트 (할인율은 빨강)
                  if (data.discountRate != null && data.discountRate! > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '-${data.discountRate!.toInt()}%',
                      style: AppTypography.sub.copyWith(
                        fontSize: 12,
                        color: AppColors.negative, // 작은 빨강 텍스트
                      ),
                    ),
                  ],
                  if (data.statusText != null && data.discountRate == null) ...[
                    const SizedBox(width: 6),
                    Text(
                      data.statusText!,
                      style: AppTypography.sub.copyWith(
                        fontSize: 12,
                        color: AppColors.textSub,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (data.imageUrl != null && data.imageUrl!.isNotEmpty) {
      return Image.network(
        data.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.divider.withOpacity(0.3),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: AppColors.textSub.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// ProductCardData를 ProductTileData로 변환하는 헬퍼
/// 기존 ProductCardData와의 호환성을 위해 제공
class ProductTileDataHelper {
  /// market/presentation/widgets/product_card.dart의 ProductCardData를 변환
  static ProductTileData fromCardData({
    required String id,
    required String brandName,
    required String productName,
    String? imageUrl,
    required int price,
    int? originalPrice,
    double? discountRate,
    String? statusText,
  }) {
    return ProductTileData(
      id: id,
      brandName: brandName,
      productName: productName,
      imageUrl: imageUrl,
      price: price,
      originalPrice: originalPrice,
      discountRate: discountRate,
      statusText: statusText,
    );
  }
}

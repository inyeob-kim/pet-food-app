import 'package:flutter/material.dart';
import '../../../../../ui/components/product_tile.dart';
import 'product_card.dart';

/// 그리드용 상품 타일 (2열 그리드 - ProductTile 사용)
class ProductGridCard extends StatelessWidget {
  final ProductCardData data;
  final VoidCallback? onTap;

  const ProductGridCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileData = ProductTileDataHelper.fromCardData(
      id: data.id,
      brandName: data.brandName,
      productName: data.productName,
      imageUrl: data.imageUrl,
      price: data.price,
      originalPrice: data.originalPrice,
      discountRate: data.discountRate,
    );
    
    return ProductTile(
      data: tileData,
      onTap: onTap,
    );
  }
}

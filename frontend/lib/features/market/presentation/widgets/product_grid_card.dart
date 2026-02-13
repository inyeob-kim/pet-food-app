import 'package:flutter/material.dart';
import '../../../../../ui/components/product_tile.dart';
import '../../../../../data/models/product_dto.dart';

/// 그리드용 상품 타일 (2열 그리드 - ProductTile 사용)
class ProductGridCard extends StatelessWidget {
  final ProductDto product;
  final VoidCallback? onTap;

  const ProductGridCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileData = ProductTileDataHelper.fromProductDto(product);
    
    return ProductTile(
      data: tileData,
      onTap: onTap,
    );
  }
}

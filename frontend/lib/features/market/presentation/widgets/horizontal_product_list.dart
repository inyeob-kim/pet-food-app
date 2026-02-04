import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../ui/components/product_tile.dart';
import 'product_card.dart';

/// 가로 스크롤 상품 리스트 (토스/폴센트 스타일 - ProductTile 사용)
class HorizontalProductList extends StatelessWidget {
  final List<ProductCardData> products;
  final Function(String productId)? onProductTap;

  const HorizontalProductList({
    super.key,
    required this.products,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 280, // ProductTile 높이 + 여유
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          final tileData = ProductTileDataHelper.fromCardData(
            id: product.id,
            brandName: product.brandName,
            productName: product.productName,
            imageUrl: product.imageUrl,
            price: product.price,
            originalPrice: product.originalPrice,
            discountRate: product.discountRate,
          );
          
          return SizedBox(
            width: 170,
            child: ProductTile(
              data: tileData,
              onTap: () {
                if (onProductTap != null) {
                  onProductTap!(product.id);
                } else {
                  // 기본 동작: 상품 상세 페이지로 이동
                  context.push(RoutePaths.productDetailPath(product.id));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

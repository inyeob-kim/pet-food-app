import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_paths.dart';
import 'product_card.dart';
import 'horizontal_product_card.dart';

/// 가로 스크롤 상품 리스트 (폴센트 스타일)
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
      height: 290, // 상품 카드 높이 + 여유 (overflow 방지)
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return HorizontalProductCard(
            data: product,
            width: 170,
            onTap: () {
              if (onProductTap != null) {
                onProductTap!(product.id);
              } else {
                // 기본 동작: 상품 상세 페이지로 이동
                context.push(RoutePaths.productDetailPath(product.id));
              }
            },
          );
        },
        ),
      ),
    );
  }
}

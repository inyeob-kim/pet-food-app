import 'package:flutter/material.dart';
import 'product_card.dart';

/// 그리드용 상품 카드 (2열 그리드)
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
    return ProductCard(
      data: data,
      onTap: onTap,
    );
  }
}

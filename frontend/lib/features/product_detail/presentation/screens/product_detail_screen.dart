import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../data/mock/figma_mock_data.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/utils/price_formatter.dart';

/// Figma 디자인 기반 Product Detail Screen
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final product = FigmaMockData.mockProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => FigmaMockData.mockProducts[0],
    );

    final discount = product.comparePrice != null
        ? ((product.comparePrice! - product.price) / product.comparePrice! * 100).round()
        : 0;
    final petData = FigmaMockData.petData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            FigmaAppBar(
              title: '제품 상세',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Hero
                      Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 320,
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFFF7F8FA),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFFF7F8FA),
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    product.isWatched
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 24,
                                    color: product.isWatched
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            // Product Info
                            Text(
                              product.brand,
                              style: AppTypography.small.copyWith(
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: AppTypography.h2.copyWith(
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Price - Strongest Visual Element
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                if (discount > 0) ...[
                                  Text(
                                    '$discount%',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Text(
                                  PriceFormatter.formatWithCurrency(product.price),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            if (product.comparePrice != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                PriceFormatter.formatWithCurrency(product.comparePrice!),
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF6B7280),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            // Price Comparison Message
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                '💰 평균 시장 가격보다 18% 저렴합니다',
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Price Graph Section
                            Text(
                              '가격 히스토리',
                              style: AppTypography.body.copyWith(
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  '가격 그래프 플레이스홀더',
                                  style: AppTypography.small.copyWith(
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Alert CTA Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications,
                                          size: 20,
                                          color: Color(0xFF2563EB),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '가격 알림',
                                              style: AppTypography.body.copyWith(
                                                color: const Color(0xFF111827),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '목표 가격 이하로 떨어지면 알림 받기',
                                              style: AppTypography.small.copyWith(
                                                color: const Color(0xFF6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: FigmaPrimaryButton(
                                      text: '알림 설정',
                                      variant: ButtonVariant.small,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Ingredient Analysis
                            Text(
                              '영양 분석',
                              style: AppTypography.body.copyWith(
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (product.protein != null)
                              _buildNutritionItem('단백질', product.protein!),
                            const SizedBox(height: 12),
                            if (product.fat != null)
                              _buildNutritionItem('지방', product.fat!),
                            const SizedBox(height: 12),
                            if (product.fiber != null)
                              _buildNutritionItem('섬유질', product.fiber!),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFF16A34A).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '✓ ${petData['name']}의 영양 요구사항에 적합합니다',
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Sticky Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF7F8FA),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        product.isWatched
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 24,
                        color: product.isWatched
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: FigmaPrimaryButton(
                  text: '구매하기',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF111827),
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

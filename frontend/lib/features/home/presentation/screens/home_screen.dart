import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/figma_section_header.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../ui/widgets/figma_product_tile.dart';
import '../../../../../data/mock/figma_mock_data.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../features/onboarding/data/repositories/onboarding_repository.dart';
import '../../../../../core/utils/price_formatter.dart';

/// Figma 디자인 기반 Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendedProduct = FigmaMockData.mockProducts[0];
    final petData = FigmaMockData.petData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar with test button
            Container(
              color: Colors.white,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '홈',
                    style: AppTypography.body.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  // 테스트용 온보딩 버튼 (나중에 제거 예정)
                  TextButton(
                    onPressed: () async {
                      // 온보딩 완료 상태 초기화
                      final onboardingRepo = OnboardingRepositoryImpl();
                      await onboardingRepo.setOnboardingCompleted(false);
                      // 온보딩 첫 화면으로 이동
                      if (context.mounted) {
                        context.go(RoutePaths.onboarding);
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '온보딩',
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Pet Summary Section
                      _buildPetSummary(petData),
                      const SizedBox(height: 32),
                      // Recommendation Section
                      _buildRecommendationSection(
                        context,
                        recommendedProduct,
                        petData['name'] as String,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetSummary(Map<String, dynamic> petData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${petData['name']}의 요약',
                    style: AppTypography.h2.copyWith(
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${petData['breed']}, ${petData['age']}살',
                    style: AppTypography.small.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${petData['weight']}kg',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Text(
                  '현재 체중',
                  style: AppTypography.small.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'BCS ${petData['bcs']}',
                '이상적',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '285',
                'kcal/일',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '180g',
                '사료/일',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.small.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(
    BuildContext context,
    ProductTileData product,
    String petName,
  ) {
    final discount = product.comparePrice != null
        ? ((product.comparePrice! - product.price) / product.comparePrice! * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FigmaSectionHeader(
          title: '$petName에게 추천',
          subtitle: '나이, 체중, 활동 수준을 기반으로',
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 192,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 192,
                    color: const Color(0xFFF7F8FA),
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: AppTypography.body.copyWith(
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Price Metric Row
                    Row(
                      children: [
                        if (discount > 0)
                          Text(
                            '$discount%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        if (discount > 0) const SizedBox(width: 8),
                        Text(
                          PriceFormatter.formatWithCurrency(product.price),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    if (product.comparePrice != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        PriceFormatter.formatWithCurrency(product.comparePrice!),
                        style: AppTypography.small.copyWith(
                          color: const Color(0xFF6B7280),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Conditional Judgment
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '✓ 이 제품은 $petName의 영양 요구사항에 완벽하게 부합합니다',
                        style: AppTypography.small.copyWith(
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // CTA Button
                    FigmaPrimaryButton(
                      text: '상세보기',
                      onPressed: () {
                        context.push('/product-detail/${product.id}');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../ui/widgets/figma_pill_chip.dart';
import '../../../../../ui/widgets/figma_product_tile.dart';
import '../../../../../ui/widgets/figma_empty_state.dart';
import '../../../../../data/mock/figma_mock_data.dart';
import '../../../../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Watch Screen
class FigmaWatchScreen extends StatefulWidget {
  const FigmaWatchScreen({super.key});

  @override
  State<FigmaWatchScreen> createState() => _FigmaWatchScreenState();
}

class _FigmaWatchScreenState extends State<FigmaWatchScreen> {
  String _sortBy = 'recent';

  @override
  Widget build(BuildContext context) {
    final watchedProducts = FigmaMockData.mockProducts
        .where((p) => p.isWatched)
        .toList();
    final isEmpty = watchedProducts.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
              children: [
                const FigmaAppBar(title: '관심'),
                if (isEmpty)
                  Expanded(
                    child: FigmaEmptyState(
                    emoji: '❤️',
                    title: '아직 관심 제품이 없습니다',
                    description: '제품을 관심 목록에 추가하면 가격 알림과 업데이트를 받을 수 있습니다',
                    ctaText: '제품 둘러보기',
                    onCTA: () {
                      context.go('/market');
                    },
                    ),
                  )
              else
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const SizedBox(height: 24),
                        // Summary Hero Number
                        Text(
                          '${watchedProducts.length}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '관심 목록에 있는 제품',
                          style: AppTypography.body.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Sorting Pills
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FigmaPillChip(
                                label: '최근',
                                selected: _sortBy == 'recent',
                                onTap: () => setState(() => _sortBy = 'recent'),
                              ),
                              const SizedBox(width: 8),
                              FigmaPillChip(
                                label: '가격 하락',
                                selected: _sortBy == 'price-drop',
                                onTap: () => setState(() => _sortBy = 'price-drop'),
                              ),
                              const SizedBox(width: 8),
                              FigmaPillChip(
                                label: '최저가',
                                selected: _sortBy == 'lowest',
                                onTap: () => setState(() => _sortBy = 'lowest'),
                              ),
                              const SizedBox(width: 8),
                              FigmaPillChip(
                                label: '최고 평점',
                                selected: _sortBy == 'rating',
                                onTap: () => setState(() => _sortBy = 'rating'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Product Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: watchedProducts.length,
                          itemBuilder: (context, index) {
                            final product = watchedProducts[index];
                            return FigmaProductTile(
                              product: product,
                              onTap: () {
                                context.push('/product-detail/${product.id}');
                              },
                              layout: ProductTileLayout.grid,
                            );
                          },
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
}

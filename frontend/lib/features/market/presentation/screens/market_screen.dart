import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/figma_search_bar.dart';
import '../../../../../ui/widgets/figma_section_header.dart';
import '../../../../../ui/widgets/figma_product_tile.dart';
import '../../../../../ui/widgets/figma_pill_chip.dart';
import '../../../../../data/mock/figma_mock_data.dart';
import '../../../../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Market Screen
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedCategory = 'all';
  final List<String> _categories = [
    '전체',
    '강아지 사료',
    '고양이 사료',
    '간식',
    '영양제',
  ];

  @override
  Widget build(BuildContext context) {
    final hotDeals = FigmaMockData.mockProducts
        .where((p) => p.comparePrice != null)
        .toList();
    final popular = FigmaMockData.mockProducts.take(4).toList();
    final petData = FigmaMockData.petData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // 화면 터치 시 포커스 해제
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              // Sticky AppBar
              Container(
                color: Colors.white,
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '마켓',
                      style: AppTypography.body.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    // 스크롤 시 포커스 해제
                    if (notification is ScrollStartNotification) {
                      FocusScope.of(context).unfocus();
                    }
                    return false;
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제품 검색 바 (화면 맨 위)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: const FigmaSearchBar(placeholder: '제품 검색'),
                          ),
                          // Hot Deals Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FigmaSectionHeader(
                                  title: '핫딜',
                                  subtitle: '한정 시간 특가',
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: hotDeals.length,
                              itemBuilder: (context, index) {
                                final product = hotDeals[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: FigmaProductTile(
                                    product: product,
                                    onTap: () {
                                      context.push('/product-detail/${product.id}');
                                    },
                                    layout: ProductTileLayout.horizontal,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Popular Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FigmaSectionHeader(
                                  title: '인기',
                                  subtitle: '반려동물들이 가장 좋아하는',
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: popular.length,
                              itemBuilder: (context, index) {
                                final product = popular[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: FigmaProductTile(
                                    product: product,
                                    onTap: () {
                                      context.push('/product-detail/${product.id}');
                                    },
                                    layout: ProductTileLayout.horizontal,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Recommendation Banner
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFEFF6FF),
                                    Color(0xFFF7F8FA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${petData['name']}에게 맞춤 추천',
                                    style: AppTypography.body.copyWith(
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${petData['name']}의 프로필을 기반으로 사료 추천 받기',
                                    style: AppTypography.small.copyWith(
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        '추천 보기',
                                        style: AppTypography.small.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Category Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: _categories.map((category) {
                                final key = category.toLowerCase().replaceAll(' ', '-');
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FigmaPillChip(
                                    label: category,
                                    selected: _selectedCategory == key,
                                    onTap: () => setState(() => _selectedCategory = key),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Full Product Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.68,
                              ),
                              itemCount: FigmaMockData.mockProducts.length,
                              itemBuilder: (context, index) {
                                final product = FigmaMockData.mockProducts[index];
                                return FigmaProductTile(
                                  product: product,
                                  onTap: () {
                                    context.push('/product-detail/${product.id}');
                                  },
                                  layout: ProductTileLayout.grid,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

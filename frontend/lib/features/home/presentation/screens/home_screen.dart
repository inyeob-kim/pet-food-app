import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../ui/widgets/app_scaffold.dart';
import '../../../../ui/widgets/app_top_bar.dart';
import '../../../../ui/widgets/card_container.dart';
import '../../../../ui/theme/app_typography.dart';
import '../../../../ui/theme/app_spacing.dart';
import '../../../../core/widgets/loading.dart';
import '../../../feed/ui/components/food_recommendation_card.dart';
import '../../../feed/ui/components/price_history_mini.dart';
import '../../../feed/ui/components/alert_rule_tile.dart';
import '../controllers/home_controller.dart';
import '../widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);

    return AppScaffold(
      appBar: const AppTopBar(title: '오늘'),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state.isLoading) {
      return const LoadingWidget();
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(homeControllerProvider.notifier).loadRecommendations();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final items = state.recommendations?.items ?? [];
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeControllerProvider.notifier).loadRecommendations();
      },
      child: ListView(
        children: [
          // 샘플: 사료 추천 카드
          FoodRecommendationCard(
            brand: '로얄캐닌',
            name: '미니 어덜트 강아지 사료 3kg',
            currentPrice: 45000,
            diffPercent: -12.5,
            verdictLabel: '지금 사도 됨',
            isAlertOn: false,
            onToggleAlert: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림 설정 준비중')),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 샘플: 가격 히스토리 미니
          PriceHistoryMini(
            lowest: 42000,
            avg: 48000,
            current: 45000,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 샘플: 알림 규칙 타일
          CardContainer(
            child: Column(
              children: [
                AlertRuleTile(
                  title: '평균가 이하 알림',
                  description: '14일 평균가보다 낮아지면 알림',
                  enabled: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('알림 ${value ? "켜짐" : "꺼짐"}')),
                    );
                  },
                ),
                const Divider(height: 1),
                AlertRuleTile(
                  title: '최저가 갱신 알림',
                  description: '새로운 최저가가 기록되면 알림',
                  enabled: false,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('알림 ${value ? "켜짐" : "꺼짐"}')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 우리 아이 추천 섹션
          _SectionCard(
            title: '우리 아이 추천',
            child: items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: Text(
                      '반려동물 정보를 등록해주세요',
                      style: AppTypography.body,
                    ),
                  )
                : Column(
                    children: items
                        .take(5)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sectionGap,
                            ),
                            child: ProductCard(item: item),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          
          // 오늘 사도 되는 사료 섹션
          _SectionCard(
            title: '오늘 사도 되는 사료',
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Text(
                '준비중',
                style: AppTypography.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sectionGap),
          child,
        ],
      ),
    );
  }
}

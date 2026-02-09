import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../ui/widgets/match_score_badge.dart';
import '../../../../../ui/widgets/card_container.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/price_formatter.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../controllers/my_controller.dart';

/// 실제 API 데이터를 사용하는 My Screen
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myControllerProvider);

    // 로딩 상태
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: LoadingWidget()),
      );
    }

    // 에러 상태
    if (state.error != null && state.petSummary == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: EmptyStateWidget(
          title: state.error ?? '오류가 발생했습니다',
          buttonText: '다시 시도',
          onButtonPressed: () => ref.read(myControllerProvider.notifier).refresh(),
        ),
      );
    }

    final petSummary = state.petSummary;
    final settings = [
      SettingData(
        icon: Icons.notifications,
        label: '알림 설정',
        hasToggle: true,
      ),
      SettingData(
        icon: Icons.lock,
        label: '개인정보 보호',
        hasChevron: true,
      ),
      SettingData(
        icon: Icons.help_outline,
        label: '도움말',
        hasChevron: true,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FigmaAppBar(title: '더보기'),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Greeting
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      petSummary != null
                                          ? '안녕하세요, ${petSummary.name}님'
                                          : '안녕하세요',
                                      style: AppTypography.h2.copyWith(
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '오늘도 건강한 하루 보내세요',
                                      style: AppTypography.small.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // NEW: Recent Recommendation History
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '최근 추천 히스토리',
                              style: AppTypography.body.copyWith(
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                '전체보기',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.recentRecommendations.isNotEmpty)
                        ..._buildRecentRecommendations(state.recentRecommendations),
                      const SizedBox(height: 16),
                      // Notification Settings
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '설정',
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF111827),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...settings.map((setting) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildSettingItem(setting),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Point Summary Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color(0xFFEFF6FF),
                          showBorder: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '사용 가능 포인트',
                                    style: AppTypography.body.copyWith(
                                      color: const Color(0xFF111827),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${state.totalPoints.toLocaleString()}P',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '다음 구매 시 할인받으세요',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: FigmaPrimaryButton(
                                  text: '혜택 보기',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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

  List<Widget> _buildRecentRecommendations(List<RecentRecommendationData> recommendations) {
    return recommendations.map((recommendation) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: CardContainer(
          padding: const EdgeInsets.all(16),
          onTap: () {
            context.push('/products/${recommendation.productId}');
          },
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.recommendedAt != null
                          ? '${recommendation.recommendedAt!.year}.${recommendation.recommendedAt!.month.toString().padLeft(2, '0')}.${recommendation.recommendedAt!.day.toString().padLeft(2, '0')}'
                          : '최근',
                      style: AppTypography.small.copyWith(
                        fontSize: 11,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation.productName,
                      style: AppTypography.small.copyWith(
                        color: const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (recommendation.matchScore != null)
                          MatchScoreBadge(
                            score: recommendation.matchScore!,
                            size: MatchScoreSize.small,
                          ),
                        if (recommendation.matchScore != null)
                          const SizedBox(width: 8),
                        if (recommendation.price != null)
                          Text(
                            PriceFormatter.formatWithCurrency(recommendation.price!),
                            style: AppTypography.small.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSettingItem(SettingData setting) {
    Color iconBgColor;
    Color iconColor;
    
    if (setting.icon == Icons.notifications) {
      iconBgColor = const Color(0xFFFEF3C7);
      iconColor = const Color(0xFFF59E0B);
    } else {
      iconBgColor = const Color(0xFFF7F8FA);
      iconColor = const Color(0xFF6B7280);
    }

    return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  setting.icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  setting.label,
                  style: AppTypography.body.copyWith(
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              if (setting.hasToggle)
                Container(
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              else if (setting.hasChevron)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
            ],
          );
  }
}

class SettingData {
  final IconData icon;
  final String label;
  final String? value;
  final bool hasToggle;
  final bool hasChevron;

  SettingData({
    required this.icon,
    required this.label,
    this.value,
    this.hasToggle = false,
    this.hasChevron = false,
  });
}

extension IntExtension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}

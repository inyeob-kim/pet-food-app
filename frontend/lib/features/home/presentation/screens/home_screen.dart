import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/widgets/app_scaffold.dart';
import '../../../../../ui/theme/app_typography.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/router/route_paths.dart';
import '../../../../../core/widgets/state_handler.dart';
import '../../../../../ui/widgets/app_buttons.dart';
import '../controllers/home_controller.dart';
import '../widgets/pet_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/today_empty_state.dart';
import '../../../../core/widgets/debug_panel.dart';

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
      ref.read(homeControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);

    return AppScaffold(
      appBar: _buildAppBar(state),
      body: Column(
        children: [
          Expanded(child: _buildBody(context, state)),
          // 디버그 패널 (디버그 빌드에서만)
          const DebugPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(HomeState state) {
    if (state.hasPet && state.petSummary != null) {
      return AppBar(
        title: Text(
          '오늘, ${state.petSummary!.name}에게 딱 맞는 사료 🐾',
          style: AppTypography.title,
        ),
        elevation: 0,
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
      );
    }
    return AppBar(
      title: Text('오늘', style: AppTypography.title),
      elevation: 0,
      backgroundColor: AppColors.bg,
      surfaceTintColor: AppColors.bg,
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    // Primary Pet 존재 → 정상 홈
    if (state.hasPet) {
      return StateHandler(
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: false,
        onRetry: () {
          ref.read(homeControllerProvider.notifier).initialize();
        },
        child: _buildHomeWithPet(context, state),
      );
    }

    // Pet 없음 → Empty State
    if (state.isNoPet) {
      return StateHandler(
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: false,
        onRetry: () {
          ref.read(homeControllerProvider.notifier).initialize();
        },
        child: _buildEmptyState(context),
      );
    }

    // 로딩/에러 처리
    return StateHandler(
      isLoading: state.isLoading,
      error: state.error,
      isEmpty: false,
      onRetry: () {
        ref.read(homeControllerProvider.notifier).initialize();
      },
      child: const SizedBox.shrink(),
    );
  }

  /// B 상태: Pet이 있는 정상 홈
  Widget _buildHomeWithPet(BuildContext context, HomeState state) {
    final petSummary = state.petSummary!;
    final topRecommendation = state.recommendations?.items.isNotEmpty == true
        ? state.recommendations!.items.first
        : null;

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeControllerProvider.notifier).refreshRecommendations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('방금 업데이트됨'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + 80, // 디버그 패널 공간
        ),
        children: [
          // 내 아이 섹션 (카드 없음)
          PetCard(pet: petSummary),
          const SizedBox(height: 28),

          // 진행 힌트 (로딩 중일 때만)
          if (state.isLoadingRecommendations) ...[
            Text(
              '${petSummary.name}에게 딱 맞는 사료 찾는 중...',
              style: AppTypography.body,
            ),
            const SizedBox(height: 28),
          ],

          // 추천 사료 섹션 (토스 스타일 - 카드 없음)
          RecommendationCard(
            topRecommendation: topRecommendation,
            isLoading: state.isLoadingRecommendations,
            petName: petSummary.name,
            onWhyRecommended: () {
              // TODO: 추천 근거 상세 모달 표시
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('추천 근거: 알레르기 제외, 나이/체중 반영, 최저가'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 28),

          // 판단 문장 (CTA 버튼 위) - 평균보다 저렴한 경우만
          if (topRecommendation != null && 
              topRecommendation!.deltaPercent != null &&
              topRecommendation!.avgPrice > topRecommendation!.currentPrice)
            Text(
              '지금은 평균보다 저렴한 구간이에요',
              style: AppTypography.sub.copyWith(
                color: AppColors.textSub,
              ),
            ),
          if (topRecommendation != null && 
              topRecommendation!.deltaPercent != null &&
              topRecommendation!.avgPrice > topRecommendation!.currentPrice)
            const SizedBox(height: 16),

          // 메인 CTA: 맞춤 사료 보러가기
          SizedBox(
            height: 54, // 52~56 범위
            child: ElevatedButton(
              onPressed: () {
                if (topRecommendation != null) {
                  context.push(
                    RoutePaths.productDetailPath(topRecommendation.product.id),
                  );
                } else {
                  // 추천이 없으면 추천 목록 화면으로 (TODO)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('추천 목록 화면 준비중')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // 16~18 범위
                ),
                elevation: 0,
              ),
              child: Text(
                '${petSummary.name} 맞춤 사료 보러가기',
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// C 상태: Pet 없음 Empty State
  Widget _buildEmptyState(BuildContext context) {
    return TodayEmptyState(
      onAddProfile: () {
        context.push(RoutePaths.petProfile);
      },
    );
  }
}

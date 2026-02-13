import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../ui/widgets/app_top_bar.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../controllers/benefits_controller.dart';

/// 실제 API 데이터를 사용하는 Benefits Screen
class BenefitsScreen extends ConsumerStatefulWidget {
  const BenefitsScreen({super.key});

  @override
  ConsumerState<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends ConsumerState<BenefitsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(benefitsControllerProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(benefitsControllerProvider);

    // 로딩 상태
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: LoadingWidget()),
      );
    }

    // 에러 상태
    if (state.error != null && state.missions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: EmptyStateWidget(
          title: state.error ?? '오류가 발생했습니다',
          buttonText: '다시 시도',
          onButtonPressed: () => ref.read(benefitsControllerProvider.notifier).refresh(),
        ),
      );
    }

    final totalPoints = state.totalPoints;
    final availablePoints = state.availablePoints;
    final missions = state.missions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: '혜택'),
            Expanded(
              child: CupertinoScrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      // Hero Point Section
                      Container(
                        padding: const EdgeInsets.all(24), // Card Padding p-6 sm:p-8
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16), // rounded-2xl
                          border: Border.all(
                            color: AppColors.border,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight, // Light Blue #EFF6FF
                                    borderRadius: BorderRadius.circular(16), // rounded-2xl
                                  ),
                                  child: const Icon(
                                    Icons.card_giftcard,
                                    size: 24,
                                    color: AppColors.primary, // Primary Blue #2563EB
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '내 포인트',
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${totalPoints.toLocaleString()}P',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary, // Primary Blue #2563EB
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${availablePoints.toLocaleString()}P 더 받을 수 있어요',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Mission List Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '미션 완료하고 포인트 받기',
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${state.completedCount}/${missions.length}',
                            style: AppTypography.small.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Mission Cards
                      ...missions.map((mission) => _buildMissionCard(context, mission)),
                      const SizedBox(height: AppSpacing.lg),
                      // Points Usage
                      Container(
                        padding: const EdgeInsets.all(24), // Card Padding
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight, // Light Blue #EFF6FF
                          borderRadius: BorderRadius.circular(16), // rounded-2xl
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '포인트 사용 방법',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '100P = 100원 할인 (다음 구매 시 자동 적용)',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl * 2),
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

  Widget _buildMissionCard(BuildContext context, MissionData mission) {
    return GestureDetector(
      onTap: () {
        _showMissionBottomSheet(context, mission);
      },
      child: Container(
        padding: const EdgeInsets.all(20), // Card Padding
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: mission.completed
              ? AppColors.statusLight // Light Green
              : Colors.white,
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          border: Border.all(
            color: mission.completed
                ? AppColors.status.withOpacity(0.2)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: mission.completed
                    ? AppColors.status // Green
                    : AppColors.primaryLight, // Light Blue #EFF6FF
                borderRadius: BorderRadius.circular(16), // rounded-2xl
              ),
              child: Icon(
                mission.completed ? Icons.check_circle : Icons.flag,
                size: 24,
                color: mission.completed
                    ? Colors.white
                    : AppColors.primary, // Primary Blue #2563EB
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: AppTypography.body.copyWith(
                      color: mission.completed
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description,
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '+${mission.reward}P',
                        style: AppTypography.small.copyWith(
                          color: mission.completed
                              ? AppColors.status // Green
                              : AppColors.primary, // Primary Blue #2563EB
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (!mission.completed) ...[
                        const SizedBox(width: 8),
                        Text(
                          '· ${mission.current}/${mission.total} 완료',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showMissionBottomSheet(BuildContext context, MissionData mission) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _MissionBottomSheet(mission: mission),
    );
  }
}

/// 미션 상세 바텀 시트
class _MissionBottomSheet extends StatelessWidget {
  final MissionData mission;

  const _MissionBottomSheet({required this.mission});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grabber
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon and Title
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: mission.completed
                                        ? AppColors.status // Green
                                        : AppColors.primaryLight, // Light Blue #EFF6FF
                                    borderRadius: BorderRadius.circular(16), // rounded-2xl
                                  ),
                                  child: Icon(
                                    mission.completed 
                                        ? Icons.check_circle 
                                        : Icons.flag,
                                    size: 24,
                                    color: mission.completed
                                        ? Colors.white
                                        : AppColors.primary, // Primary Blue #2563EB
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mission.title,
                                        style: AppTypography.h3.copyWith(
                                          color: AppColors.textPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '+${mission.reward}P',
                                        style: AppTypography.body.copyWith(
                                          color: mission.completed
                                              ? AppColors.status // Green
                                              : AppColors.primary, // Primary Blue #2563EB
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        const SizedBox(height: AppSpacing.xl),
                        // Description
                        Text(
                          mission.description,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Progress
                        if (!mission.completed) ...[
                          Text(
                            '진행 상황',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${mission.current}/${mission.total} 완료',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${((mission.current / mission.total) * 100).round()}%',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.primaryBlue, // 결정/정보용
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: mission.total > 0
                                  ? mission.current / mission.total
                                  : 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary, // Primary Blue #2563EB
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl * 2),
                      ],
                    ),
                  ),
                ),
                // Fixed Bottom Button
                if (!mission.completed)
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: AppColors.divider,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: 미션 시작 로직 구현
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary, // Primary Blue #2563EB
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // rounded-xl
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            '시작하기',
                            style: AppTypography.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension IntExtension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}

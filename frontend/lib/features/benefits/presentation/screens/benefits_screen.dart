import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../ui/widgets/figma_app_bar.dart';
import '../../../../../ui/widgets/figma_primary_button.dart';
import '../../../../../ui/widgets/card_container.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
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
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(benefitsControllerProvider.notifier).refresh();
    });
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
            const FigmaAppBar(title: '혜택'),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Hero Point Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.card_giftcard,
                                    size: 24,
                                    color: Color(0xFF2563EB),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '내 포인트',
                                    style: AppTypography.body.copyWith(
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${totalPoints.toLocaleString()}P',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${availablePoints.toLocaleString()}P 더 받을 수 있어요',
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mission List Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '미션 완료하고 포인트 받기',
                              style: AppTypography.body.copyWith(
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${state.completedCount}/${missions.length}',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mission Cards
                      ...missions.map((mission) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildMissionCard(context, mission),
                      )),
                      const SizedBox(height: 16),
                      // Points Usage
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color(0xFFEFF6FF),
                          showBorder: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '포인트 사용 방법',
                                style: AppTypography.body.copyWith(
                                  color: const Color(0xFF111827),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '100P = 100원 할인 (다음 구매 시 자동 적용)',
                                style: AppTypography.small.copyWith(
                                  color: const Color(0xFF6B7280),
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

  Widget _buildMissionCard(BuildContext context, MissionData mission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardContainer(
        padding: const EdgeInsets.all(16),
        backgroundColor: mission.completed
            ? const Color(0xFFF0FDF4)
            : Colors.white,
        showBorder: mission.completed,
        onTap: () {
          _showMissionBottomSheet(context, mission);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: mission.completed
                    ? const Color(0xFF16A34A)
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                mission.completed ? Icons.check_circle : Icons.flag,
                size: 18,
                color: mission.completed
                    ? Colors.white
                    : const Color(0xFF6B7280),
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
                          : const Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description,
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '+${mission.reward}P',
                        style: AppTypography.small.copyWith(
                          color: mission.completed
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!mission.completed) ...[
                        const SizedBox(width: 8),
                        Text(
                          '· ${mission.current}/${mission.total} 완료',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
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
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  void _showMissionBottomSheet(BuildContext context, MissionData mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Grabber
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                ? const Color(0xFF16A34A)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            mission.completed ? Icons.check_circle : Icons.flag,
                            size: 24,
                            color: mission.completed
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mission.title,
                                style: AppTypography.h2.copyWith(
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+${mission.reward}P',
                                style: AppTypography.body.copyWith(
                                  color: mission.completed
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFF2563EB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      mission.description,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Progress
                    if (!mission.completed) ...[
                      Text(
                        '진행 상황',
                        style: AppTypography.body.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                              color: const Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: mission.total > 0
                              ? mission.current / mission.total
                              : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Fixed Bottom Button
            if (!mission.completed)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: FigmaPrimaryButton(
                      text: '시작하기',
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: 미션 시작 로직 구현
                      },
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

extension IntExtension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}

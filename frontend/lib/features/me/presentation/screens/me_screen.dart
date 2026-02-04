import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/widgets/app_scaffold.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../ui/theme/app_typography.dart';
import '../../../../../ui/components/section_header.dart';
import '../../../../../app/router/route_paths.dart';
import 'package:pet_food_app/features/home/presentation/controllers/home_controller.dart';

/// 마이 화면 (토스 스타일 - 상태 요약 대시보드)
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final petSummary = homeState.petSummary;
    final petName = petSummary?.name ?? '우리 아이';
    final healthSummary = petSummary?.healthSummary ?? '특이사항 없음';
    
    // 건강 상태 요약 문구
    final healthStatusText = healthSummary.isEmpty || healthSummary == '특이사항 없음'
        ? '특이사항 없이 건강해요'
        : healthSummary;

    return AppScaffold(
      appBar: AppBar(
        title: Text('마이', style: AppTypography.title),
        elevation: 0,
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
      ),
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // 상단 상태 요약 (카드 없이)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$petName의 건강 리포트',
                  style: AppTypography.title,
                ),
                const SizedBox(height: 12),
                // 상태 pill 또는 한 줄 강조
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.positive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.positive,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        healthStatusText,
                        style: AppTypography.sub.copyWith(
                          color: AppColors.positive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 프로필 정보 섹션
          const SectionHeader(
            title: '프로필',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (petSummary != null) ...[
                  _ProfileItem(
                    label: '견종',
                    value: petSummary.species == 'DOG' ? '강아지' : '고양이',
                  ),
                  const SizedBox(height: 12),
                  _ProfileItem(
                    label: '체중',
                    value: '${petSummary.weightKg}kg',
                  ),
                  const SizedBox(height: 12),
                  _ProfileItem(
                    label: '나이',
                    value: petSummary.ageSummary,
                  ),
                ] else ...[
                  _ProfileItem(label: '견종', value: '-'),
                  const SizedBox(height: 12),
                  _ProfileItem(label: '체중', value: '-'),
                  const SizedBox(height: 12),
                  _ProfileItem(label: '나이', value: '-'),
                ],
                const SizedBox(height: 16),
                // 프로필 수정 링크
                GestureDetector(
                  onTap: () {
                    context.push(RoutePaths.petProfile);
                  },
                  child: Text(
                    '프로필 수정',
                    style: AppTypography.sub.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 알림 설정 섹션
          const SectionHeader(
            title: '알림 설정',
            subtitle: '가격 변동과 추천을 알려드려요',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _SettingItem(
                  title: '가격 알림',
                  subtitle: '최저가일 때 알려드려요',
                  value: true,
                  onChanged: (value) {
                    // TODO: 알림 설정 업데이트
                  },
                ),
                const SizedBox(height: 16),
                _SettingItem(
                  title: '푸시 알림',
                  subtitle: '앱 푸시 알림 받기',
                  value: true,
                  onChanged: (value) {
                    // TODO: 알림 설정 업데이트
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 포인트 섹션 (카드 제거)
          const SectionHeader(
            title: '포인트',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 큰 숫자로 표시 (hero 스타일)
                Text(
                  '0 P',
                  style: AppTypography.heroNumber,
                ),
                const SizedBox(height: 8),
                Text(
                  '사료 구매 시 포인트를 적립할 수 있습니다',
                  style: AppTypography.sub,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.sub.copyWith(
            color: AppColors.textSub,
          ),
        ),
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.sub,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

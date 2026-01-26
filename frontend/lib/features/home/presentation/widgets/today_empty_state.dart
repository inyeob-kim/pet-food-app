import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../ui/icons/app_icons.dart';
import '../../../../ui/widgets/app_buttons.dart';

/// 토스 스타일 Today EmptyState (프로필 없음)
class TodayEmptyState extends StatelessWidget {
  final VoidCallback? onAddProfile;
  final VoidCallback? onBrowseProducts;

  const TodayEmptyState({
    super.key,
    this.onAddProfile,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AddCard (흰색 카드, radius 16, 중앙 + 아이콘)
            _AddCard(
              onTap: onAddProfile ?? () {
                context.push(RoutePaths.petProfile);
              },
            ),
            const SizedBox(height: 28),
            // 설명 텍스트 (토스 스타일: 더 큰 간격)
            Text(
              '프로필을 등록하면 우리 아이에게 맞는 사료를 추천하고\n가격 알림을 받을 수 있어요',
              style: AppTypography.body2.copyWith(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            // Primary CTA 버튼
            AppPrimaryButton(
              text: '반려동물 프로필 추가',
              onPressed: onAddProfile ?? () {
                context.push(RoutePaths.petProfile);
              },
            ),
            // Secondary CTA 버튼 (선택적)
            if (onBrowseProducts != null) ...[
              const SizedBox(height: 12),
              AppSecondaryButton(
                text: '대표 사료 둘러보기',
                onPressed: onBrowseProducts,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// AddCard 위젯 (토스 스타일)
class _AddCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 140, // 토스 스타일: 더 큰 카드
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card, // 토스 스타일: 그림자 추가
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // + 아이콘 (토스 스타일: 더 크게)
            AppIcons.addCircle(size: 56),
            const SizedBox(height: 12),
            // '추가' 텍스트
            Text(
              '추가',
              style: AppTypography.body2.copyWith(
                fontSize: 15,
                color: AppColors.iconMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

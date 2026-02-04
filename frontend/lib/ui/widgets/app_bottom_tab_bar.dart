import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';
import '../icons/app_icons.dart';

/// iOS 스타일 Bottom Tab Bar (DESIGN_GUIDE.md 기반)
class AppBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingHorizontal,
        0,
        AppSpacing.pagePaddingHorizontal,
        8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card + 10),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TabItem(
                icon: AppIcons.home(isActive: currentIndex == 0),
                label: '홈',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _TabItem(
                icon: AppIcons.favorite(isActive: currentIndex == 1),
                label: '관심',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _TabItem(
                icon: AppIcons.search(isActive: currentIndex == 2),
                label: '검색',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _TabItem(
                icon: AppIcons.gift(isActive: currentIndex == 3),
                label: '혜택',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _TabItem(
                icon: AppIcons.person(isActive: currentIndex == 4),
                label: '마이',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 탭 아이템
class _TabItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.0 : 0.95,
              duration: const Duration(milliseconds: 150),
              child: icon,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 10, // 약간 줄여서 오버플로우 방지
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


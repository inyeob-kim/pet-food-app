import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../ui/widgets/app_buttons.dart';

/// 알림 받기 CTA 섹션
class AlertCtaSection extends StatelessWidget {
  final bool isTrackingCreated;
  final bool isTrackingLoading;
  final VoidCallback? onAlertTap;

  const AlertCtaSection({
    super.key,
    this.isTrackingCreated = false,
    this.isTrackingLoading = false,
    this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isTrackingCreated) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.positiveGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.positiveGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '가격 알림이 설정되었습니다',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_down,
                color: AppColors.positiveGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '지금은 평균보다 저렴해요',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '이 가격을 놓치지 않으려면?',
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            text: '가격 알림 받기',
            onPressed: isTrackingLoading ? null : onAlertTap,
            height: 48,
          ),
        ],
      ),
    );
  }
}

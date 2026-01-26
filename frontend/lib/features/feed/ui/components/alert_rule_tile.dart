import 'package:flutter/material.dart';
import '../../../../ui/theme/app_colors.dart';
import '../../../../ui/theme/app_typography.dart';
import '../../../../ui/theme/app_spacing.dart';

/// 알림 규칙 타일 컴포넌트
class AlertRuleTile extends StatelessWidget {
  final String title;
  final String? description;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const AlertRuleTile({
    super.key,
    required this.title,
    this.description,
    required this.enabled,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null
          ? () => onChanged!(!enabled)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.sectionGap,
        ),
        child: Row(
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
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: enabled,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}


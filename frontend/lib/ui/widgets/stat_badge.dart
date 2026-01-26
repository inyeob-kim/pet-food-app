import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

/// 통계 배지 위젯 (+/- % 표시)
class StatBadge extends StatelessWidget {
  final double value; // 퍼센트 값
  final bool isPositive;
  final String? prefix;

  const StatBadge({
    super.key,
    required this.value,
    this.isPositive = true,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value.abs();
    final sign = isPositive ? '+' : '-';
    final color = isPositive ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.pillRadius),
      ),
      child: Text(
        '${prefix ?? ''}$sign${displayValue.toStringAsFixed(1)}%',
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


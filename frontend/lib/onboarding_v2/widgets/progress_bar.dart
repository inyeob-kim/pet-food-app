import 'package:flutter/material.dart';
import '../../theme_v2/app_colors.dart';

/// Progress bar component matching React implementation
class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / total).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      height: 4,
      decoration: BoxDecoration(
        color: AppColorsV2.divider,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColorsV2.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../../theme_v2/app_colors.dart';
import '../../theme_v2/app_typography.dart';

/// Step 8: BCS - matches React Step8BCS
class Step08BCS extends StatelessWidget {
  final int value;
  final ValueChanged<int> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step08BCS({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  String getBCSLabel(int score) {
    if (score <= 3) return '조금 마른 편이에요';
    if (score <= 6) return '딱 좋아요! 💚';
    return '조금 관리해볼까요?';
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🧡',
      title: '체형은 어느 쪽에 가까울까요? 🧡',
      ctaText: '다음',
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value',
                style: AppTypographyV2.hero.copyWith(
                  color: AppColorsV2.primary,
                ),
              ),
              Text(
                getBCSLabel(value),
                style: AppTypographyV2.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColorsV2.textSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColorsV2.primary,
              inactiveTrackColor: AppColorsV2.divider,
              thumbColor: AppColorsV2.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 4,
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 9,
              divisions: 8,
              onChanged: (val) => onUpdate(val.toInt()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('마른 편', style: AppTypographyV2.small),
              Text('통통한 편', style: AppTypographyV2.small),
            ],
          ),
        ],
      ),
    );
  }
}

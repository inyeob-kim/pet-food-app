import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/toss_text_input.dart';
import '../../theme_v2/app_typography.dart';

/// Step 5: Breed (Dog only) - matches React Step5Breed
class Step05Breed extends StatelessWidget {
  final String value;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step05Breed({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  bool get isValid => value.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🐶',
      title: '어떤 품종인가요? 🐶',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '품종',
            style: AppTypographyV2.sub.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TossTextInput(
            value: value,
            onChanged: onUpdate,
            placeholder: '예: 골든리트리버, 믹스',
          ),
          const SizedBox(height: 8),
          Text(
            '품종명을 입력하거나 "믹스"를 입력해주세요',
            style: AppTypographyV2.sub,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/toss_text_input.dart';
import '../../app/theme/app_typography.dart';

/// Step 7: Weight - matches React Step7Weight
class Step07Weight extends StatelessWidget {
  final String value;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step07Weight({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  bool get isValid {
    final weight = double.tryParse(value.trim());
    return weight != null && weight >= 0.1 && weight <= 99.9;
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '⚖️',
      title: '몸무게는 얼마인가요? ⚖️',
      subtitle: '최근 측정 기준이면 좋아요',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '몸무게 (kg)',
            style: AppTypography.small.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TossTextInput(
            value: value,
            onChanged: onUpdate,
            placeholder: '0.0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          Text(
            '0.1~99.9kg 사이의 값을 입력해주세요',
            style: AppTypography.small,
          ),
        ],
      ),
    );
  }
}

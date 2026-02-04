import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/toss_text_input.dart';
import '../../theme_v2/app_typography.dart';

/// Step 2: Pet Name - matches React Step2PetName
class Step02PetName extends StatelessWidget {
  final String value;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step02PetName({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  bool get isValid => value.length >= 1 && value.length <= 20;

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🐾',
      title: '우리 아이 이름은요? 🐾',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이름',
            style: AppTypographyV2.sub.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TossTextInput(
            value: value,
            onChanged: onUpdate,
            placeholder: '이름을 입력해주세요',
            maxLength: 20,
          ),
          const SizedBox(height: 8),
          Text(
            '1~20자',
            style: AppTypographyV2.sub,
          ),
        ],
      ),
    );
  }
}

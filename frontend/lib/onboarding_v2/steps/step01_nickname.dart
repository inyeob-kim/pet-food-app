import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/toss_text_input.dart';
import '../../theme_v2/app_typography.dart';

/// Step 1: Nickname - matches React Step1Nickname
class Step01Nickname extends StatelessWidget {
  final String value;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final int currentStep;
  final int totalSteps;

  const Step01Nickname({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.currentStep,
    required this.totalSteps,
  });

  bool get isValid => value.length >= 2 && value.length <= 12;

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      emoji: '😊',
      title: '안녕하세요 😊',
      subtitle: '헤이제노에서 쓸 닉네임만 먼저 정해볼까요?',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: AppTypographyV2.sub.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TossTextInput(
            value: value,
            onChanged: onUpdate,
            placeholder: '닉네임을 입력해주세요',
            maxLength: 12,
          ),
          const SizedBox(height: 8),
          Text(
            '2~12자',
            style: AppTypographyV2.sub,
          ),
        ],
      ),
    );
  }
}

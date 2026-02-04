import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/pill_chip.dart';

/// Step 9: Health Concerns - matches React Step9HealthConcerns
class Step09Health extends StatelessWidget {
  final List<String> value;
  final ValueChanged<List<String>> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step09Health({
    super.key,
    required this.value,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  static const List<String> healthOptions = [
    '없어요',
    '알레르기',
    '장/소화',
    '치아/구강',
    '비만',
    '호흡기',
    '피부/털',
    '관절',
    '눈/눈물',
    '신장/요로',
    '심장',
    '노령',
  ];

  void handleToggle(String concern) {
    if (concern == '없어요') {
      // "없어요" is exclusive
      onUpdate(value.contains('없어요') ? [] : ['없어요']);
    } else {
      // Remove "없어요" if selecting anything else
      final filtered = value.where((v) => v != '없어요').toList();
      if (filtered.contains(concern)) {
        onUpdate(filtered.where((v) => v != concern).toList());
      } else {
        onUpdate([...filtered, concern]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🩺',
      title: '요즘 신경 쓰이는 건강 고민이 있나요? 🩺',
      ctaText: '다음',
      onCTAClick: onNext,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: healthOptions.map((option) {
          return PillChip(
            label: option,
            selected: value.contains(option),
            onTap: () => handleToggle(option),
          );
        }).toList(),
      ),
    );
  }
}

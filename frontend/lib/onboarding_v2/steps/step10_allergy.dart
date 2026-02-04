import 'package:flutter/material.dart';
import '../onboarding_shell.dart';
import '../widgets/pill_chip.dart';
import '../widgets/toss_text_input.dart';
import '../../theme_v2/app_typography.dart';

/// Step 10: Food Allergies - matches React Step10FoodAllergies
class Step10Allergy extends StatelessWidget {
  final List<String> value;
  final String otherAllergy;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step10Allergy({
    super.key,
    required this.value,
    required this.otherAllergy,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  static const List<String> allergyOptions = [
    '없어요',
    '소고기',
    '닭고기',
    '돼지고기',
    '오리고기',
    '양고기',
    '생선',
    '계란',
    '유제품',
    '밀/글루텐',
    '옥수수',
    '콩',
    '기타',
  ];

  void handleToggle(String allergy) {
    if (allergy == '없어요') {
      // "없어요" is exclusive
      onUpdate({
        'foodAllergies': value.contains('없어요') ? [] : ['없어요'],
        'otherAllergy': '',
      });
    } else {
      // Remove "없어요" if selecting anything else
      final filtered = value.where((v) => v != '없어요').toList();
      if (filtered.contains(allergy)) {
        final newValue = filtered.where((v) => v != allergy).toList();
        onUpdate({
          'foodAllergies': newValue,
          'otherAllergy': allergy == '기타' ? '' : otherAllergy,
        });
      } else {
        onUpdate({'foodAllergies': [...filtered, allergy]});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🍗',
      title: '피해야 하는 재료가 있나요? 🍗',
      ctaText: '다음',
      onCTAClick: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergyOptions.map((option) {
              return PillChip(
                label: option,
                selected: value.contains(option),
                onTap: () => handleToggle(option),
              );
            }).toList(),
          ),
          if (value.contains('기타')) ...[
            const SizedBox(height: 16),
            Text(
              '기타 재료를 입력해주세요',
              style: AppTypographyV2.sub.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TossTextInput(
              value: otherAllergy,
              onChanged: (val) => onUpdate({'otherAllergy': val}),
              placeholder: '기타 알레르기 재료를 입력해주세요',
            ),
          ],
        ],
      ),
    );
  }
}

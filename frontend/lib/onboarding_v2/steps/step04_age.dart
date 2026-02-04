import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../onboarding_shell.dart';
import '../widgets/selection_card.dart';
import '../widgets/toss_text_input.dart';
import '../../theme_v2/app_typography.dart';

/// Step 4: Age - matches React Step4Age
class Step04Age extends StatelessWidget {
  final String ageType; // 'birthdate' | 'approximate' | ''
  final String birthdate;
  final String approximateAge;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step04Age({
    super.key,
    required this.ageType,
    required this.birthdate,
    required this.approximateAge,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  bool get isValid {
    return (ageType == 'birthdate' && birthdate.isNotEmpty) ||
        (ageType == 'approximate' && approximateAge.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: currentStep,
      totalSteps: totalSteps,
      onBack: onBack,
      emoji: '🎂',
      title: '나이를 어떻게 알려주실래요? 🎂',
      ctaText: '다음',
      ctaDisabled: !isValid,
      onCTAClick: onNext,
      child: Column(
        children: [
          SelectionCard(
            selected: ageType == 'birthdate',
            onTap: () => onUpdate({'ageType': 'birthdate'}),
            emoji: '📅',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '생년월일 알아요',
                  style: AppTypographyV2.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (ageType == 'birthdate') ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _buildDatePicker(context),
            ),
          ],
          const SizedBox(height: 12),
          SelectionCard(
            selected: ageType == 'approximate',
            onTap: () => onUpdate({'ageType': 'approximate'}),
            emoji: '🎈',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '대략 나이만',
                  style: AppTypographyV2.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (ageType == 'approximate') ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: TossTextInput(
                value: approximateAge,
                onChanged: (val) => onUpdate({'approximateAge': val}),
                placeholder: '예: 2살 3개월',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    // For mobile, use CupertinoDatePicker in a bottom sheet
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Save selected date
                        Navigator.pop(context);
                      },
                      child: const Text('완료'),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime.now().subtract(const Duration(days: 7300)), // ~20 years
                    initialDateTime: birthdate.isNotEmpty
                        ? DateTime.tryParse(birthdate)
                        : DateTime.now().subtract(const Duration(days: 365)),
                    onDateTimeChanged: (date) {
                      onUpdate({'birthdate': date.toIso8601String().split('T')[0]});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Text(
              birthdate.isEmpty ? '생년월일을 선택해주세요' : birthdate,
              style: AppTypographyV2.body.copyWith(
                color: birthdate.isEmpty
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF111827),
              ),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_footer.dart';
import '../widgets/emoji_icon.dart';
import '../widgets/species_card.dart';
import '../../data/models/onboarding_step.dart';

/// Step 3: 종 선택
class Step03SpeciesSelectionScreen extends ConsumerStatefulWidget {
  const Step03SpeciesSelectionScreen({super.key});

  @override
  ConsumerState<Step03SpeciesSelectionScreen> createState() =>
      _Step03SpeciesSelectionScreenState();
}

class _Step03SpeciesSelectionScreenState
    extends ConsumerState<Step03SpeciesSelectionScreen> {
  String? _selectedSpecies;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingControllerProvider);
      if (state.profile.species != null) {
        setState(() {
          _selectedSpecies = state.profile.species;
        });
      }
    });
  }

  void _onSpeciesSelected(String species) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedSpecies = species;
    });
    
    // 선택 즉시 저장 (다음 버튼을 누르기 전에)
    final profile = ref.read(onboardingControllerProvider).profile;
    ref.read(onboardingControllerProvider.notifier).saveProfile(
          profile.copyWith(species: species),
        );
  }

  Future<void> _onNext() async {
    if (_selectedSpecies == null) return;

    HapticFeedback.lightImpact();
    await ref.read(onboardingControllerProvider.notifier).nextStep();
  }

  void _onBack() {
    HapticFeedback.lightImpact();
    ref.read(onboardingControllerProvider.notifier).previousStep();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedSpecies != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(
              currentStep: OnboardingStep.species,
              onBack: _onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const EmojiIcon(emoji: '🐶🐱', size: 80),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '어떤 친구인가요? 🐶🐱',
                      style: AppTypography.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // 종 선택 카드
                    Row(
                      children: [
                        Expanded(
                          child: SpeciesCard(
                            emoji: '🐶',
                            label: '강아지',
                            isSelected: _selectedSpecies == 'dog',
                            onTap: () => _onSpeciesSelected('dog'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: SpeciesCard(
                            emoji: '🐱',
                            label: '고양이',
                            isSelected: _selectedSpecies == 'cat',
                            onTap: () => _onSpeciesSelected('cat'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            OnboardingFooter(
              buttonText: '다음',
              onPressed: isValid ? _onNext : null,
              isEnabled: isValid,
            ),
          ],
        ),
      ),
    );
  }
}

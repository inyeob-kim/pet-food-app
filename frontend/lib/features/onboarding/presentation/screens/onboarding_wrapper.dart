import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/onboarding_step.dart';
import '../controllers/onboarding_controller.dart';
import 'step_01_welcome_nickname.dart';
import 'step_02_pet_name.dart';
import 'step_03_species_selection.dart';

/// 온보딩 플로우 래퍼
class OnboardingWrapper extends ConsumerStatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  ConsumerState<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends ConsumerState<OnboardingWrapper> {
  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드 (생성자에서 자동으로 호출되지만 명시적으로 호출)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Controller가 생성되면서 자동으로 _loadSavedData()가 호출됩니다
      // 여기서는 단순히 watch만 하면 됩니다
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final step = state.currentStep;
    
    print('[OnboardingWrapper] build() called, current step: $step, isLoading: ${state.isLoading}');

    // 로딩 중일 때
    if (state.isLoading && step == OnboardingStep.welcome) {
      print('[OnboardingWrapper] Showing loading screen');
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FB),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 현재 단계에 맞는 화면 표시
    Widget screen;
    switch (step) {
      case OnboardingStep.welcome:
        print('[OnboardingWrapper] Showing Step01WelcomeNicknameScreen');
        screen = const Step01WelcomeNicknameScreen();
        break;
      case OnboardingStep.petName:
        print('[OnboardingWrapper] Showing Step02PetNameScreen');
        screen = const Step02PetNameScreen();
        break;
      case OnboardingStep.species:
        print('[OnboardingWrapper] Showing Step03SpeciesSelectionScreen');
        screen = const Step03SpeciesSelectionScreen();
        break;
      // TODO: 나머지 화면 추가
      case OnboardingStep.birthMode:
      case OnboardingStep.breed:
      case OnboardingStep.sexNeutered:
      case OnboardingStep.weight:
      case OnboardingStep.bodyCondition:
      case OnboardingStep.healthConcerns:
      case OnboardingStep.foodAllergies:
      case OnboardingStep.photo:
        print('[OnboardingWrapper] Step $step not yet implemented, showing placeholder');
        screen = _PlaceholderScreen(step: step);
        break;
    }

    return screen;
  }
}

/// 아직 구현되지 않은 단계를 위한 플레이스홀더 화면
class _PlaceholderScreen extends StatelessWidget {
  final OnboardingStep step;

  const _PlaceholderScreen({required this.step});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${step.stepNumber}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '이 단계는 아직 구현 중입니다.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Step: ${step.key}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

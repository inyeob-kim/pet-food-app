import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../ui/widgets/app_buttons.dart';
import '../../data/models/onboarding_step.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/emoji_icon.dart';
import '../widgets/onboarding_footer.dart';
import '../widgets/onboarding_header.dart';

/// Step 1: Welcome + 닉네임
class Step01WelcomeNicknameScreen extends ConsumerStatefulWidget {
  const Step01WelcomeNicknameScreen({super.key});

  @override
  ConsumerState<Step01WelcomeNicknameScreen> createState() =>
      _Step01WelcomeNicknameScreenState();
}

class _Step01WelcomeNicknameScreenState
    extends ConsumerState<Step01WelcomeNicknameScreen> {
  final _nicknameController = TextEditingController();
  final _focusNode = FocusNode();

  // 랜덤 닉네임 풀
  final _randomNicknames = [
    '뽀뽀맘',
    '멍멍이집사',
    '냥이사랑',
    '골든맘',
    '츄츄파파',
    '강아지천사',
    '고양이별',
    '사랑이맘',
    '행복한집사',
    '반려동물러버',
  ];

  @override
  void initState() {
    super.initState();
    // 저장된 닉네임 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingControllerProvider);
      if (state.nickname != null && state.nickname!.isNotEmpty) {
        _nicknameController.text = state.nickname!;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onRandomNickname() {
    HapticFeedback.lightImpact();
    final random = _randomNicknames[
        DateTime.now().millisecondsSinceEpoch % _randomNicknames.length];
    setState(() {
      _nicknameController.text = random;
    });
    _focusNode.unfocus();
  }

  Future<void> _onNext() async {
    final nickname = _nicknameController.text.trim();
    print('[Step01] _onNext() called, nickname: $nickname');
    
    if (nickname.length < 2 || nickname.length > 12) {
      print('[Step01] Invalid nickname length: ${nickname.length}');
      return;
    }

    HapticFeedback.lightImpact();
    print('[Step01] HapticFeedback triggered');
    
    try {
      // 닉네임 저장 및 다음 단계로 이동
      print('[Step01] Saving nickname...');
      await ref.read(onboardingControllerProvider.notifier).saveNickname(nickname);
      print('[Step01] Nickname saved');
      
      print('[Step01] Moving to next step...');
      await ref.read(onboardingControllerProvider.notifier).nextStep();
      print('[Step01] Next step called');
      
      // 상태 확인
      final currentState = ref.read(onboardingControllerProvider);
      print('[Step01] Current step after nextStep: ${currentState.currentStep}');
      print('[Step01] Current nickname: ${currentState.nickname}');
    } catch (e, stackTrace) {
      print('[Step01] Error in _onNext: $e');
      print('[Step01] StackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _nicknameController.text.trim();
    final isValid = nickname.length >= 2 && nickname.length <= 12;
    print('[Step01] build() called, nickname: $nickname, isValid: $isValid');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(
              currentStep: OnboardingStep.welcome,
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const EmojiIcon(emoji: '😊', size: 80),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '안녕하세요 😊',
                      style: AppTypography.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '헤이제노에서 쓸 닉네임만 먼저 정해볼까요?',
                      style: AppTypography.lead,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // 닉네임 입력
                    TextField(
                      controller: _nicknameController,
                      focusNode: _focusNode,
                      maxLength: 12,
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력해주세요',
                        counterText: '${nickname.length}/12',
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                      ),
                      style: AppTypography.body,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // 랜덤 닉네임 버튼
                    AppSecondaryButton(
                      text: '🎲 추천받기',
                      onPressed: _onRandomNickname,
                    ),
                    if (nickname.isNotEmpty && !isValid)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          nickname.length < 2
                              ? '닉네임은 2자 이상이어야 해요'
                              : '닉네임은 12자 이하여야 해요',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.dangerRed,
                          ),
                        ),
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

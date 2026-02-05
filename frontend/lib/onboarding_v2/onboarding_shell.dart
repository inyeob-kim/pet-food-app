import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import 'widgets/progress_bar.dart';
import 'widgets/primary_cta_button.dart';

/// Onboarding shell layout matching React OnboardingLayout
class OnboardingShell extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final String emoji;
  final String title;
  final String? subtitle;
  final Widget child;
  final String ctaText;
  final bool ctaDisabled;
  final VoidCallback onCTAClick;
  final CTASecondary? ctaSecondary;
  final Widget? leadingWidget;

  const OnboardingShell({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    required this.emoji,
    required this.title,
    this.subtitle,
    required this.child,
    required this.ctaText,
    this.ctaDisabled = false,
    required this.onCTAClick,
    this.ctaSecondary,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ProgressBar(
                  current: currentStep,
                  total: totalSteps,
                ),
              ),

              // Back Button
              if (onBack != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ),

              // Scrollable Content
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    // 스크롤 시작 시 포커스 해제
                    if (notification is ScrollStartNotification) {
                      FocusScope.of(context).unfocus();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      onBack != null ? 24 : 32,
                      16,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Leading Widget (e.g., Logo)
                        if (leadingWidget != null) ...[
                          Center(child: leadingWidget!),
                          const SizedBox(height: 24),
                        ],

                        // Emoji (only show if not empty)
                        if (emoji.isNotEmpty) ...[
                          Text(
                            emoji,
                            style: const TextStyle(fontSize: 80),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Title
                        Text(
                          title,
                          style: AppTypography.title.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        // Subtitle
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: AppTypography.small.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Content
                        child,
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom CTA
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    PrimaryCTAButton(
                      text: ctaText,
                      onPressed: ctaDisabled ? null : onCTAClick,
                      disabled: ctaDisabled,
                    ),
                    if (ctaSecondary != null) ...[
                      const SizedBox(height: 12),
                      PrimaryCTAButton(
                        text: ctaSecondary!.text,
                        onPressed: ctaSecondary!.onClick,
                        isSecondary: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

/// Secondary CTA configuration
class CTASecondary {
  final String text;
  final VoidCallback onClick;

  const CTASecondary({
    required this.text,
    required this.onClick,
  });
}

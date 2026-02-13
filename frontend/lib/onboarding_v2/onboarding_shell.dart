import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';
import 'widgets/progress_bar.dart';
import 'widgets/primary_cta_button.dart';

/// Onboarding shell layout - DESIGN_GUIDE v1.0 준수
class OnboardingShell extends StatefulWidget {
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
  State<OnboardingShell> createState() => _OnboardingShellState();
}

class _OnboardingShellState extends State<OnboardingShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar (design.mdc: 상단 고정, 충분한 패딩)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: ProgressBar(
                current: widget.currentStep,
                total: widget.totalSteps,
              ),
            ),

            // Back Button (design.mdc: 명확한 위치, 충분한 터치 영역)
            if (widget.onBack != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  left: AppSpacing.lg,
                  bottom: AppSpacing.sm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    minSize: 0,
                    onPressed: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),

            // Scrollable Content
            Expanded(
              child: CupertinoScrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    widget.onBack != null ? AppSpacing.xl : AppSpacing.xl * 1.5,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Leading Widget (e.g., Logo)
                          if (widget.leadingWidget != null) ...[
                            Center(child: widget.leadingWidget!),
                            const SizedBox(height: AppSpacing.xl),
                          ],

                          // Emoji (only show if not empty) - design.mdc: Hero Section 스타일
                          if (widget.emoji.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                              ),
                              child: Text(
                                widget.emoji,
                                style: const TextStyle(fontSize: 56),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],

                          // Title (design.mdc: Hero/Display 스타일)
                          Text(
                            widget.title,
                            style: AppTypography.h2.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.25, // leading-tight
                            ),
                          ),

                          // Subtitle (design.mdc: Body Large 스타일)
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              widget.subtitle!,
                              style: AppTypography.body.copyWith(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                height: 1.625, // leading-relaxed
                              ),
                            ),
                          ],

                          const SizedBox(height: AppSpacing.xxl),

                          // Content
                          widget.child,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom CTA (design.mdc: 고정 바텀 바, 그림자 효과)
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryCTAButton(
                    text: widget.ctaText,
                    onPressed: widget.ctaDisabled ? null : widget.onCTAClick,
                    disabled: widget.ctaDisabled,
                  ),
                  if (widget.ctaSecondary != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    PrimaryCTAButton(
                      text: widget.ctaSecondary!.text,
                      onPressed: widget.ctaSecondary!.onClick,
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

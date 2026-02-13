import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../onboarding_shell.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadows.dart';

/// Step 11: Photo - DESIGN_GUIDE v1.0 준수
class Step11Photo extends StatefulWidget {
  final String value; // base64 or file path
  final String petName;
  final ValueChanged<String> onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const Step11Photo({
    super.key,
    required this.value,
    required this.petName,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  State<Step11Photo> createState() => _Step11PhotoState();
}

class _Step11PhotoState extends State<Step11Photo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _pickedFile = image;
        });
        // Store file path (in production, convert to base64 or upload)
        widget.onUpdate(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = widget.value.isNotEmpty || _pickedFile != null;

    return OnboardingShell(
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      onBack: widget.onBack,
      emoji: '📸',
      title: '아이 사진을 올려볼까요?',
      subtitle: '나중에 해도 괜찮아요',
      ctaText: '헤이제노 시작하기',
      onCTAClick: widget.onNext,
      ctaSecondary: hasPhoto
          ? CTASecondary(
              text: '사진 변경',
              onClick: () => _showImageSourceDialog(context),
            )
          : null,
      child: hasPhoto
          ? TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.95 + (0.05 * value.clamp(0.0, 1.0)),
                    child: Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.card), // rounded-2xl
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        boxShadow: AppShadows.cardHover,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.card - 2),
                        child: Image.file(
                          File(_pickedFile?.path ?? widget.value),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.card), // rounded-2xl
                  border: Border.all(
                    color: AppColors.border,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '사진을 선택해주세요',
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '탭하여 사진을 선택하세요',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg), // rounded-2xl
          ),
          boxShadow: AppShadows.modal,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 드래그 핸들 (design.mdc: 명확한 시각적 피드백)
              Container(
                margin: const EdgeInsets.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.md,
                ),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              // 갤러리 선택
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  '갤러리에서 선택',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              // 사진 촬영
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  '사진 촬영',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: AppSpacing.lg + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

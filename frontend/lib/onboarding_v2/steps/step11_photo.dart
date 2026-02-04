import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../onboarding_shell.dart';
import '../../theme_v2/app_colors.dart';
import '../../theme_v2/app_typography.dart';

/// Step 11: Photo - matches React Step11Photo
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
      title: '아이 사진을 올려볼까요? 📸',
      subtitle: '나중에 해도 괜찮아요',
      ctaText: hasPhoto ? '헤이제노 시작하기' : '건너뛰기',
      onCTAClick: widget.onNext,
      ctaSecondary: hasPhoto
          ? CTASecondary(
              text: '사진 변경',
              onClick: () => _showImageSourceDialog(context),
            )
          : null,
      child: hasPhoto
          ? Container(
              width: double.infinity,
              height: 256,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorsV2.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_pickedFile?.path ?? widget.value),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                width: double.infinity,
                height: 256,
                decoration: BoxDecoration(
                  color: AppColorsV2.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColorsV2.divider,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.upload,
                        size: 28,
                        color: AppColorsV2.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '사진을 선택해주세요',
                      style: AppTypographyV2.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '탭하여 사진을 선택하세요',
                      style: AppTypographyV2.sub,
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
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('사진 촬영'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}

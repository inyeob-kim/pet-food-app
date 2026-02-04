import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';
import 'figma_primary_button.dart';

/// Figma 디자인 기반 Empty State 위젯
class FigmaEmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String? ctaText;
  final VoidCallback? onCTA;

  const FigmaEmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.ctaText,
    this.onCTA,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTypography.h2.copyWith(
              color: const Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 280,
            child: Text(
              description,
              style: AppTypography.body.copyWith(
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (ctaText != null && onCTA != null) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: 280,
              child: FigmaPrimaryButton(
                text: ctaText!,
                onPressed: onCTA,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

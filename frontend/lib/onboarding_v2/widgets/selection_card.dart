import 'package:flutter/material.dart';
import '../../theme_v2/app_colors.dart';

/// Selection card component matching React implementation
class SelectionCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final String? emoji;

  const SelectionCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColorsV2.primarySoft : AppColorsV2.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColorsV2.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Text(
                emoji!,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: child,
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColorsV2.primary : AppColorsV2.divider,
                  width: 2,
                ),
                color: selected ? AppColorsV2.primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';

/// Figma 디자인 기반 AppBar 위젯
class FigmaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool transparent;

  const FigmaAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.transparent = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: transparent ? Colors.transparent : Colors.white,
      child: Row(
        children: [
          if (onBack != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: AppTypography.body.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadows.dart';

/// 카드 컨테이너 위젯 (DESIGN_GUIDE.md v4.1 - Data-Driven Premium Platform Edition)
/// 
/// 규칙:
/// - padding: AppSpacing.xl (24px) 넉넉하게
/// - borderRadius: AppRadius.md (12px)
/// - backgroundColor: AppColors.surface (White)
/// - border: 얇은 회색 border (1px, #E5E7EB)
/// - shadow: 미세한 shadow (0 2px 6px rgba(0,0,0,0.03))
class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showShadow;
  final Color? borderColor;
  final double? borderWidth;
  @deprecated // v4.1: 더 이상 사용되지 않음, 호환성을 위해 유지
  final bool isHomeStyle; // Legacy 호환성

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.showBorder = true,
    this.showShadow = true, // v4.1: Premium shadow 기본 사용
    this.borderColor,
    this.borderWidth,
    this.isHomeStyle = false, // Legacy 호환성
  });

  @override
  Widget build(BuildContext context) {
    // DESIGN_GUIDE v4.1: padding은 AppSpacing.xl (24px)로 통일
    final effectivePadding = padding ?? const EdgeInsets.all(AppSpacing.xl);
    
    // DESIGN_GUIDE v4.1: 카드 배경은 surface (White)
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    
    // DESIGN_GUIDE v4.1: borderRadius는 AppRadius.md (12px)
    final effectiveBorderRadius = BorderRadius.circular(AppRadius.md);
    
    final content = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: showBorder ? Border.all(
          color: borderColor ?? AppColors.border, // #E5E7EB
          width: borderWidth ?? 1,
        ) : null,
        boxShadow: showShadow ? AppShadows.card : null, // Premium shadow
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: content,
      );
    }

    return content;
  }
}

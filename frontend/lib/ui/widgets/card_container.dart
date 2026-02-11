import 'package:flutter/material.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';

/// 카드 컨테이너 위젯 (DESIGN_GUIDE.md v2.2 - 쌤대신 구조 + 헤이제노 감성)
/// 
/// 규칙:
/// - padding: AppSpacing.xl (24px) 넉넉하게
/// - borderRadius: AppRadius.md (12px)
/// - backgroundColor: AppColors.surfaceWarm (따뜻한 크림)
/// - border: 얇은 회색 border (1px, #E5E7EB)
/// - shadow: 없음
class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool isHomeStyle; // Home 전용 스타일 프리셋
  final Color? borderColor; // 테두리 색상 커스터마이징
  final double? borderWidth; // 테두리 두께 커스터마이징

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.showBorder = true, // DESIGN_GUIDE v2.1: border 기본 사용
    this.isHomeStyle = false, // Home 전용 스타일 (기본값: false)
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    // DESIGN_GUIDE v2.2: padding은 AppSpacing.xl (24px)로 통일
    final effectivePadding = padding ?? const EdgeInsets.all(AppSpacing.xl);
    
    // DESIGN_GUIDE v2.2: 카드 배경은 surfaceWarm (따뜻한 크림)
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surfaceWarm;
    
    // DESIGN_GUIDE v2.2: borderRadius는 AppRadius.md (12px)
    final effectiveBorderRadius = BorderRadius.circular(AppRadius.md);
    
    final content = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: showBorder ? Border.all(
          color: borderColor ?? AppColors.line, // #E5E7EB
          width: borderWidth ?? 1,
        ) : null,
        // shadow 제거 (DESIGN_GUIDE v2.1 준수)
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

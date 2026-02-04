import 'package:flutter/material.dart';
import '../../app/theme/app_typography.dart';

/// Figma 디자인 기반 Search Bar 위젯
class FigmaSearchBar extends StatelessWidget {
  final String? placeholder;
  final ValueChanged<String>? onSearch;
  final TextEditingController? controller;

  const FigmaSearchBar({
    super.key,
    this.placeholder = '제품 검색',
    this.onSearch,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        style: AppTypography.body.copyWith(
          color: const Color(0xFF111827),
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: AppTypography.body.copyWith(
            color: const Color(0xFF6B7280),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF6B7280),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFFEFF6FF),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

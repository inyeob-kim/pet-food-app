import 'package:flutter/material.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';

/// 성분 분석 데이터 모델
class IngredientAnalysisData {
  final List<String> mainIngredients; // 주요 원료
  final Map<String, double> nutritionFacts; // 영양소 분석 (단백질, 지방, 섬유질, 수분 등)
  final List<String>? allergens; // 알레르기 유발 성분
  final String? description; // 기타 설명

  IngredientAnalysisData({
    required this.mainIngredients,
    required this.nutritionFacts,
    this.allergens,
    this.description,
  });
}

/// 성분 분석 섹션 위젯
class IngredientAnalysisSection extends StatelessWidget {
  final IngredientAnalysisData? data;

  const IngredientAnalysisSection({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀
        Text(
          '성분 분석',
          style: AppTypography.h3.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '주요 원료와 영양소 정보를 확인하세요',
          style: AppTypography.body2.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),

        // 주요 원료
        _buildMainIngredients(data!.mainIngredients),
        const SizedBox(height: 24),

        // 영양소 분석
        _buildNutritionFacts(data!.nutritionFacts),
        
        // 알레르기 유발 성분
        if (data!.allergens != null && data!.allergens!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildAllergens(data!.allergens!),
        ],

        // 기타 설명
        if (data!.description != null && data!.description!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildDescription(data!.description!),
        ],
      ],
    );
  }

  Widget _buildMainIngredients(List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주요 원료',
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < ingredients.length - 1 ? 8 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ingredient,
                        style: AppTypography.body2.copyWith(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionFacts(Map<String, double> nutritionFacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '영양소 분석',
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            children: nutritionFacts.entries.map((entry) {
              final label = entry.key;
              final value = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == nutritionFacts.keys.last ? 0 : 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: AppTypography.body2.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '${value.toStringAsFixed(1)}%',
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergens(List<String> allergens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: Colors.orange.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              '알레르기 유발 성분',
              style: AppTypography.body1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergens.map((allergen) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                allergen,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: AppTypography.body2.copyWith(
                fontSize: 13,
                color: Colors.blue.shade900,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

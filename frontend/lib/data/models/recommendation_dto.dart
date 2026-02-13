import 'package:json_annotation/json_annotation.dart';

import '../../core/constants/enums.dart';
import 'product_dto.dart';

part 'recommendation_dto.g.dart';

@JsonSerializable()
class RecommendationItemDto {
  final ProductDto product;
  @JsonKey(name: 'offer_merchant', fromJson: _merchantFromJson, toJson: _merchantToJson)
  final Merchant offerMerchant;
  @JsonKey(name: 'current_price')
  final int currentPrice;
  @JsonKey(name: 'avg_price')
  final int avgPrice;
  @JsonKey(name: 'delta_percent')
  final double? deltaPercent;
  @JsonKey(name: 'is_new_low')
  final bool isNewLow;
  @JsonKey(name: 'match_score')
  final double matchScore;
  @JsonKey(name: 'safety_score')
  final double safetyScore;
  @JsonKey(name: 'fitness_score')
  final double fitnessScore;
  @JsonKey(name: 'match_reasons')
  final List<String>? matchReasons;
  final String? explanation;
  // 애니메이션용 상세 분석 데이터
  @JsonKey(name: 'ingredient_count')
  final int? ingredientCount;
  @JsonKey(name: 'main_ingredients')
  final List<String>? mainIngredients;
  @JsonKey(name: 'allergy_ingredients')
  final List<String>? allergyIngredients;
  @JsonKey(name: 'harmful_ingredients')
  final List<String>? harmfulIngredients;
  @JsonKey(name: 'quality_checklist')
  final List<String>? qualityChecklist;
  @JsonKey(name: 'daily_amount_g')
  final double? dailyAmountG;

  RecommendationItemDto({
    required this.product,
    required this.offerMerchant,
    required this.currentPrice,
    required this.avgPrice,
    this.deltaPercent,
    required this.isNewLow,
    required this.matchScore,
    required this.safetyScore,
    required this.fitnessScore,
    this.matchReasons,
    this.explanation,
    this.ingredientCount,
    this.mainIngredients,
    this.allergyIngredients,
    this.harmfulIngredients,
    this.qualityChecklist,
    this.dailyAmountG,
  });

  factory RecommendationItemDto.fromJson(Map<String, dynamic> json) => _$RecommendationItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationItemDtoToJson(this);

  static Merchant _merchantFromJson(String value) => Merchant.fromString(value);
  static String _merchantToJson(Merchant merchant) => merchant.value;
}

@JsonSerializable()
class RecommendationResponseDto {
  @JsonKey(name: 'pet_id')
  final String petId;
  final List<RecommendationItemDto> items;
  @JsonKey(name: 'is_cached', defaultValue: false)
  final bool isCached;
  @JsonKey(name: 'last_recommended_at')
  final DateTime? lastRecommendedAt;
  final String? message;

  RecommendationResponseDto({
    required this.petId,
    required this.items,
    this.isCached = false,
    this.lastRecommendedAt,
    this.message,
  });

  factory RecommendationResponseDto.fromJson(Map<String, dynamic> json) => _$RecommendationResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationResponseDtoToJson(this);
}


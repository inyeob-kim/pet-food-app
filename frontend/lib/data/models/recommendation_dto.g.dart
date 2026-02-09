// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationItemDto _$RecommendationItemDtoFromJson(
  Map<String, dynamic> json,
) => RecommendationItemDto(
  product: ProductDto.fromJson(json['product'] as Map<String, dynamic>),
  offerMerchant: RecommendationItemDto._merchantFromJson(
    json['offer_merchant'] as String,
  ),
  currentPrice: (json['current_price'] as num).toInt(),
  avgPrice: (json['avg_price'] as num).toInt(),
  deltaPercent: (json['delta_percent'] as num?)?.toDouble(),
  isNewLow: json['is_new_low'] as bool,
  matchScore: (json['match_score'] as num).toDouble(),
  safetyScore: (json['safety_score'] as num).toDouble(),
  fitnessScore: (json['fitness_score'] as num).toDouble(),
  matchReasons: (json['match_reasons'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  explanation: json['explanation'] as String?,
);

Map<String, dynamic> _$RecommendationItemDtoToJson(
  RecommendationItemDto instance,
) => <String, dynamic>{
  'product': instance.product,
  'offer_merchant': RecommendationItemDto._merchantToJson(
    instance.offerMerchant,
  ),
  'current_price': instance.currentPrice,
  'avg_price': instance.avgPrice,
  'delta_percent': instance.deltaPercent,
  'is_new_low': instance.isNewLow,
  'match_score': instance.matchScore,
  'safety_score': instance.safetyScore,
  'fitness_score': instance.fitnessScore,
  'match_reasons': instance.matchReasons,
  'explanation': instance.explanation,
};

RecommendationResponseDto _$RecommendationResponseDtoFromJson(
  Map<String, dynamic> json,
) => RecommendationResponseDto(
  petId: json['pet_id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => RecommendationItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecommendationResponseDtoToJson(
  RecommendationResponseDto instance,
) => <String, dynamic>{'pet_id': instance.petId, 'items': instance.items};

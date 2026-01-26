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

  RecommendationItemDto({
    required this.product,
    required this.offerMerchant,
    required this.currentPrice,
    required this.avgPrice,
    this.deltaPercent,
    required this.isNewLow,
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

  RecommendationResponseDto({
    required this.petId,
    required this.items,
  });

  factory RecommendationResponseDto.fromJson(Map<String, dynamic> json) => _$RecommendationResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationResponseDtoToJson(this);
}


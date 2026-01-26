import 'package:json_annotation/json_annotation.dart';

part 'price_summary_dto.g.dart';

@JsonSerializable()
class PriceSummaryDto {
  @JsonKey(name: 'offer_id')
  final String offerId;
  @JsonKey(name: 'window_days')
  final int windowDays;
  @JsonKey(name: 'avg_price')
  final int avgPrice;
  @JsonKey(name: 'min_price')
  final int minPrice;
  @JsonKey(name: 'max_price')
  final int maxPrice;
  @JsonKey(name: 'last_price')
  final int lastPrice;
  @JsonKey(name: 'last_captured_at')
  final DateTime lastCapturedAt;

  PriceSummaryDto({
    required this.offerId,
    required this.windowDays,
    required this.avgPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.lastPrice,
    required this.lastCapturedAt,
  });

  factory PriceSummaryDto.fromJson(Map<String, dynamic> json) => _$PriceSummaryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PriceSummaryDtoToJson(this);
}


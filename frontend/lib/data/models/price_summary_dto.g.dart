// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceSummaryDto _$PriceSummaryDtoFromJson(Map<String, dynamic> json) =>
    PriceSummaryDto(
      offerId: json['offer_id'] as String,
      windowDays: (json['window_days'] as num).toInt(),
      avgPrice: (json['avg_price'] as num).toInt(),
      minPrice: (json['min_price'] as num).toInt(),
      maxPrice: (json['max_price'] as num).toInt(),
      lastPrice: (json['last_price'] as num).toInt(),
      lastCapturedAt: DateTime.parse(json['last_captured_at'] as String),
    );

Map<String, dynamic> _$PriceSummaryDtoToJson(PriceSummaryDto instance) =>
    <String, dynamic>{
      'offer_id': instance.offerId,
      'window_days': instance.windowDays,
      'avg_price': instance.avgPrice,
      'min_price': instance.minPrice,
      'max_price': instance.maxPrice,
      'last_price': instance.lastPrice,
      'last_captured_at': instance.lastCapturedAt.toIso8601String(),
    };

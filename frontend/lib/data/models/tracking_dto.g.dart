// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDto _$TrackingDtoFromJson(Map<String, dynamic> json) => TrackingDto(
  id: json['id'] as String,
  petId: json['pet_id'] as String,
  productId: json['product_id'] as String,
  status: TrackingDto._statusFromJson(json['status'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TrackingDtoToJson(TrackingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'product_id': instance.productId,
      'status': TrackingDto._statusToJson(instance.status),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

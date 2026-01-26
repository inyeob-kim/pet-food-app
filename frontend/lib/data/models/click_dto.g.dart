// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'click_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClickDto _$ClickDtoFromJson(Map<String, dynamic> json) => ClickDto(
  id: json['id'] as String,
  clickedAt: DateTime.parse(json['clicked_at'] as String),
);

Map<String, dynamic> _$ClickDtoToJson(ClickDto instance) => <String, dynamic>{
  'id': instance.id,
  'clicked_at': instance.clickedAt.toIso8601String(),
};

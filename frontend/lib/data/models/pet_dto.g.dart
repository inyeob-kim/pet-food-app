// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetDto _$PetDtoFromJson(Map<String, dynamic> json) => PetDto(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String?,
  breedCode: json['breed_code'] as String,
  weightBucketCode: json['weight_bucket_code'] as String,
  ageStage: PetDto._ageStageFromJson(json['age_stage']),
  isNeutered: json['is_neutered'] as bool?,
  isPrimary: json['is_primary'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PetDtoToJson(PetDto instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'breed_code': instance.breedCode,
  'weight_bucket_code': instance.weightBucketCode,
  'age_stage': PetDto._ageStageToJson(instance.ageStage),
  'is_neutered': instance.isNeutered,
  'is_primary': instance.isPrimary,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

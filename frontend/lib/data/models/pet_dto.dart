import 'package:json_annotation/json_annotation.dart';

import '../../core/constants/enums.dart';

part 'pet_dto.g.dart';

@JsonSerializable()
class PetDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? name;
  @JsonKey(name: 'breed_code')
  final String breedCode;
  @JsonKey(name: 'weight_bucket_code')
  final String weightBucketCode;
  @JsonKey(name: 'age_stage', fromJson: _ageStageFromJson, toJson: _ageStageToJson)
  final AgeStage ageStage;
  @JsonKey(name: 'is_neutered')
  final bool? isNeutered;
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PetDto({
    required this.id,
    required this.userId,
    this.name,
    required this.breedCode,
    required this.weightBucketCode,
    required this.ageStage,
    this.isNeutered,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PetDto.fromJson(Map<String, dynamic> json) => _$PetDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PetDtoToJson(this);

  static AgeStage _ageStageFromJson(dynamic value) {
    if (value is String) {
      return AgeStage.fromString(value);
    }
    // 기본값 반환
    return AgeStage.adult;
  }
  static String _ageStageToJson(AgeStage ageStage) => ageStage.value;
}


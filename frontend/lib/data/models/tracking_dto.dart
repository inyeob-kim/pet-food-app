import 'package:json_annotation/json_annotation.dart';

import '../../core/constants/enums.dart';

part 'tracking_dto.g.dart';

@JsonSerializable()
class TrackingDto {
  final String id;
  @JsonKey(name: 'pet_id')
  final String petId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final TrackingStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  TrackingDto({
    required this.id,
    required this.petId,
    required this.productId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrackingDto.fromJson(Map<String, dynamic> json) => _$TrackingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingDtoToJson(this);

  static TrackingStatus _statusFromJson(String value) => TrackingStatus.fromString(value);
  static String _statusToJson(TrackingStatus status) => status.value;
}


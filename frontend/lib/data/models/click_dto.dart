import 'package:json_annotation/json_annotation.dart';

part 'click_dto.g.dart';

@JsonSerializable()
class ClickDto {
  final String id;
  @JsonKey(name: 'clicked_at')
  final DateTime clickedAt;

  ClickDto({
    required this.id,
    required this.clickedAt,
  });

  factory ClickDto.fromJson(Map<String, dynamic> json) => _$ClickDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClickDtoToJson(this);
}


import 'package:json_annotation/json_annotation.dart';

import '../../core/constants/enums.dart';

part 'alert_dto.g.dart';

@JsonSerializable()
class AlertDto {
  final String id;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  @JsonKey(name: 'rule_type', fromJson: _ruleTypeFromJson, toJson: _ruleTypeToJson)
  final AlertRuleType ruleType;
  @JsonKey(name: 'target_price')
  final int? targetPrice;
  @JsonKey(name: 'cooldown_hours')
  final int cooldownHours;
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  @JsonKey(name: 'last_triggered_at')
  final DateTime? lastTriggeredAt;

  AlertDto({
    required this.id,
    required this.trackingId,
    required this.ruleType,
    this.targetPrice,
    required this.cooldownHours,
    required this.isEnabled,
    this.lastTriggeredAt,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) => _$AlertDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AlertDtoToJson(this);

  static AlertRuleType _ruleTypeFromJson(String value) => AlertRuleType.fromString(value);
  static String _ruleTypeToJson(AlertRuleType ruleType) => ruleType.value;
}


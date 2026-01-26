// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertDto _$AlertDtoFromJson(Map<String, dynamic> json) => AlertDto(
  id: json['id'] as String,
  trackingId: json['tracking_id'] as String,
  ruleType: AlertDto._ruleTypeFromJson(json['rule_type'] as String),
  targetPrice: (json['target_price'] as num?)?.toInt(),
  cooldownHours: (json['cooldown_hours'] as num).toInt(),
  isEnabled: json['is_enabled'] as bool,
  lastTriggeredAt: json['last_triggered_at'] == null
      ? null
      : DateTime.parse(json['last_triggered_at'] as String),
);

Map<String, dynamic> _$AlertDtoToJson(AlertDto instance) => <String, dynamic>{
  'id': instance.id,
  'tracking_id': instance.trackingId,
  'rule_type': AlertDto._ruleTypeToJson(instance.ruleType),
  'target_price': instance.targetPrice,
  'cooldown_hours': instance.cooldownHours,
  'is_enabled': instance.isEnabled,
  'last_triggered_at': instance.lastTriggeredAt?.toIso8601String(),
};

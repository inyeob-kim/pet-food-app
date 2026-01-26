/// 백엔드 API와 매칭되는 Enum 정의

enum AgeStage {
  puppy('PUPPY'),
  adult('ADULT'),
  senior('SENIOR');

  final String value;
  const AgeStage(this.value);

  static AgeStage fromString(String value) {
    try {
      return AgeStage.values.firstWhere(
        (e) => e.value == value.toUpperCase(),
      );
    } catch (e) {
      // 기본값 반환
      return AgeStage.adult;
    }
  }
}

enum Merchant {
  coupang('COUPANG'),
  naver('NAVER'),
  brand('BRAND');

  final String value;
  const Merchant(this.value);

  static Merchant fromString(String value) {
    return Merchant.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Merchant.coupang,
    );
  }
}

enum TrackingStatus {
  active('ACTIVE'),
  paused('PAUSED'),
  deleted('DELETED');

  final String value;
  const TrackingStatus(this.value);

  static TrackingStatus fromString(String value) {
    return TrackingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TrackingStatus.active,
    );
  }
}

enum AlertRuleType {
  belowAvg('BELOW_AVG'),
  newLow('NEW_LOW'),
  targetPrice('TARGET_PRICE');

  final String value;
  const AlertRuleType(this.value);

  static AlertRuleType fromString(String value) {
    return AlertRuleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertRuleType.belowAvg,
    );
  }
}

enum ClickSource {
  home('HOME'),
  detail('DETAIL'),
  alert('ALERT');

  final String value;
  const ClickSource(this.value);

  static ClickSource fromString(String value) {
    return ClickSource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ClickSource.home,
    );
  }
}


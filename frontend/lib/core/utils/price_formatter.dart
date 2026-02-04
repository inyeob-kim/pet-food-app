/// 가격 포맷팅 유틸리티 (공통)
class PriceFormatter {
  /// 숫자를 천 단위 콤마가 포함된 문자열로 변환
  static String format(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// 가격을 원화 형식으로 포맷팅 (예: 29,000원)
  static String formatWithCurrency(int price) {
    return '${format(price)}원';
  }

  /// 만/천 단위로 포맷팅 (예: 2만 9천원, 3만원)
  static String formatCompact(int price) {
    if (price >= 10000) {
      final man = (price / 10000).floor();
      final remainder = price % 10000;
      if (remainder == 0) {
        return '$man만원';
      } else {
        return '$man만 ${(remainder / 1000).floor()}천원';
      }
    }
    return formatWithCurrency(price);
  }

  /// 만/천 단위로 포맷팅 (원 없이, 예: 2만 9천)
  static String formatCompactWithoutCurrency(int price) {
    if (price >= 10000) {
      final man = (price / 10000).floor();
      final remainder = price % 10000;
      if (remainder == 0) {
        return '$man만';
      } else {
        return '$man만 ${(remainder / 1000).floor()}천';
      }
    }
    return format(price);
  }

  /// 할인율 포맷팅
  static String formatDiscountPercent(double? percent) {
    if (percent == null || percent <= 0) return '';
    return '${percent.toStringAsFixed(1)}% 할인';
  }
}


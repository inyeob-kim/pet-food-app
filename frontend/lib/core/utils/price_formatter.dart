/// 가격 포맷팅 유틸리티
class PriceFormatter {
  /// 숫자를 천 단위 콤마가 포함된 문자열로 변환
  static String format(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// 가격을 원화 형식으로 포맷팅
  static String formatWithCurrency(int price) {
    return '${format(price)}원';
  }

  /// 할인율 포맷팅
  static String formatDiscountPercent(double? percent) {
    if (percent == null) return '';
    if (percent >= 0) return '';
    return '${percent.abs().toStringAsFixed(1)}% 할인';
  }
}


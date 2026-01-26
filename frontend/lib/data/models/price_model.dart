class PriceModel {
  final String id;
  final String offerId;
  final int price;
  final int shippingCost;
  final int totalPrice;
  final DateTime collectedAt;

  PriceModel({
    required this.id,
    required this.offerId,
    required this.price,
    required this.shippingCost,
    required this.totalPrice,
    required this.collectedAt,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'] as String,
      offerId: json['offer_id'] as String,
      price: json['price'] as int,
      shippingCost: json['shipping_cost'] as int,
      totalPrice: json['total_price'] as int,
      collectedAt: DateTime.parse(json['collected_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_id': offerId,
      'price': price,
      'shipping_cost': shippingCost,
      'total_price': totalPrice,
      'collected_at': collectedAt.toIso8601String(),
    };
  }
}


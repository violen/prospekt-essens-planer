class Offer {
  final int? id;
  final int brochureId;
  final String productName;
  final double price;
  final String? unit;
  final String? discountInfo;
  final String? category;

  Offer({
    this.id,
    required this.brochureId,
    required this.productName,
    required this.price,
    this.unit,
    this.discountInfo,
    this.category,
  });

  Offer copyWith({
    int? id,
    int? brochureId,
    String? productName,
    double? price,
    String? unit,
    String? discountInfo,
    String? category,
  }) {
    return Offer(
      id: id ?? this.id,
      brochureId: brochureId ?? this.brochureId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      discountInfo: discountInfo ?? this.discountInfo,
      category: category ?? this.category,
    );
  }
}

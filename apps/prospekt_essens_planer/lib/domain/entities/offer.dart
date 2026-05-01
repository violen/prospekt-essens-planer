class Offer {
  final int id;
  final int brochureId;
  final String productName;
  final double price;
  final String? unit;
  final String? discountInfo;
  final String? category;

  Offer({
    required this.id,
    required this.brochureId,
    required this.productName,
    required this.price,
    this.unit,
    this.discountInfo,
    this.category,
  });
}

// lib/repositories/pricing_repository.dart
class PricingRepository {
  static const double sixInchPrice = 7.0;
  static const double footlongPrice = 11.0;

  final int quantity;
  final bool isFootlong;

  PricingRepository({required this.quantity, required this.isFootlong});

  double get totalPrice {
    final pricePerSandwich = isFootlong ? footlongPrice : sixInchPrice;
    return quantity * pricePerSandwich;
  }

  String get formattedPrice => '£${totalPrice.toStringAsFixed(2)}';
}

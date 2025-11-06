import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('calculates price for six-inch sandwiches', () {
      final repo = PricingRepository(quantity: 2, isFootlong: false);
      expect(repo.totalPrice, 14.0);
      expect(repo.formattedPrice, '£14.00');
    });
    test('calculates price for footlong sandwiches', () {
      final repo = PricingRepository(quantity: 3, isFootlong: true);
      expect(repo.totalPrice, 33.0);
      expect(repo.formattedPrice, '£33.00');
    });
    test('zero quantity yields zero price', () {
      final repo = PricingRepository(quantity: 0, isFootlong: true);
      expect(repo.totalPrice, 0.0);
      expect(repo.formattedPrice, '£0.00');
    });
  });
}

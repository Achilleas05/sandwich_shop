import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/cart.dart';
import '../../lib/models/sandwich.dart';

void main() {
  late Cart cart;
  // Six-inch veggie delight on wheat (Price: 7.00)
  final s1 = Sandwich(
    type: SandwichType.veggieDelight,
    isFootlong: false,
    breadType: BreadType.wheat,
  );
  // Footlong chicken teriyaki on white (Price: 11.00)
  final s2 = Sandwich(
    type: SandwichType.chickenTeriyaki,
    isFootlong: true,
    breadType: BreadType.white,
  );

  setUp(() {
    cart = Cart();
  });

  group('Cart Logic', () {
    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('add() creates a new item if sandwich is not in cart', () {
      cart.add(s1);
      expect(cart.items.length, 1);
      expect(cart.items.first, CartItem(sandwich: s1, quantity: 1));
      expect(cart.totalItems, 1);
    });

    test('add() increments quantity if sandwich is already in cart', () {
      cart.add(s1);
      cart.add(s1, 2);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
      expect(cart.totalItems, 3);
    });

    test('add() throws ArgumentError for non-positive quantity', () {
      expect(() => cart.add(s1, 0), throwsArgumentError);
      expect(() => cart.add(s1, -1), throwsArgumentError);
    });

    test('remove() decreases quantity of an item', () {
      cart.add(s1, 5);
      cart.remove(s1, 2);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
      expect(cart.totalItems, 3);
    });

    test('remove() removes item if quantity reaches zero', () {
      cart.add(s1, 2);
      cart.remove(s1, 2);
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });

    test('remove() removes item if quantity goes below zero', () {
      cart.add(s1, 2);
      cart.remove(s1, 3);
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });

    test('remove() does nothing if item is not in cart', () {
      cart.add(s1);
      cart.remove(s2);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);
    });

    test('remove() throws ArgumentError for non-positive quantity', () {
      cart.add(s1);
      expect(() => cart.remove(s1, 0), throwsArgumentError);
      expect(() => cart.remove(s1, -1), throwsArgumentError);
    });

    test('setQuantity() adds a new item', () {
      cart.setQuantity(s1, 3);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
      expect(cart.totalItems, 3);
    });

    test('setQuantity() updates an existing item', () {
      cart.add(s1, 1);
      cart.setQuantity(s1, 5);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 5);
      expect(cart.totalItems, 5);
    });

    test('setQuantity() removes item if quantity is 0', () {
      cart.add(s1, 3);
      cart.setQuantity(s1, 0);
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });

    test('setQuantity() does nothing for a new item with quantity 0', () {
      cart.setQuantity(s1, 0);
      expect(cart.items, isEmpty);
    });

    test('setQuantity() throws ArgumentError for negative quantity', () {
      expect(() => cart.setQuantity(s1, -1), throwsArgumentError);
    });

    test('clear() removes all items', () {
      cart.add(s1);
      cart.add(s2);
      cart.clear();
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });

    test('totalItems returns the sum of quantities', () {
      cart.add(s1, 2);
      cart.add(s2, 3);
      expect(cart.totalItems, 5);
    });

    test('totalPrice calculates correct price using PricingRepository', () {
      // s1 is six-inch (7.00), s2 is footlong (11.00)
      cart.add(s1, 2); // 2 * 7.00 = 14.00
      cart.add(s2, 3); // 3 * 11.00 = 33.00
      // Total = 14.00 + 33.00 = 47.00
      expect(cart.totalPrice, 47.00);
    });
  });

  group('Cart Serialization', () {
    test('toJson() and fromJson() correctly serialize and deserialize the cart',
        () {
      cart.add(s1, 2);
      cart.add(s2, 1);

      final json = cart.toJson();
      final newCart = Cart.fromJson(json);

      expect(newCart.totalItems, cart.totalItems);
      expect(newCart.totalPrice, cart.totalPrice);
      expect(newCart.items, orderedEquals(cart.items));
    });

    test('fromJson() handles empty items list', () {
      final json = {'items': []};
      final newCart = Cart.fromJson(json);
      expect(newCart.items, isEmpty);
    });

    test('fromJson() handles missing items key', () {
      final json = <String, dynamic>{};
      final newCart = Cart.fromJson(json);
      expect(newCart.items, isEmpty);
    });
  });

  group('CartItem', () {
    test('equality works correctly', () {
      final item1 = CartItem(sandwich: s1, quantity: 1);
      final item2 = CartItem(sandwich: s1, quantity: 1);
      final item3 = CartItem(sandwich: s1, quantity: 2);
      final item4 = CartItem(sandwich: s2, quantity: 1);

      expect(item1, equals(item2));
      expect(item1.hashCode, equals(item2.hashCode));
      expect(item1, isNot(equals(item3)));
      expect(item1, isNot(equals(item4)));
    });
  });
}

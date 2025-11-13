import 'package:flutter/foundation.dart';

import '../repositories/pricing_repository.dart';
import 'sandwich.dart';

/// Represents an item in the shopping cart, containing a [Sandwich] and its quantity.
///
/// This class is immutable. Use [copyWith] to create a modified instance.
@immutable
class CartItem {
  /// The sandwich product.
  final Sandwich sandwich;

  /// The number of this sandwich in the cart.
  final int quantity;

  /// Creates a cart item.
  /// The [quantity] must be a positive integer.
  const CartItem({
    required this.sandwich,
    required this.quantity,
  }) : assert(quantity > 0, 'Quantity must be positive.');

  /// Creates a new [CartItem] with updated properties.
  CartItem copyWith({
    Sandwich? sandwich,
    int? quantity,
  }) {
    return CartItem(
      sandwich: sandwich ?? this.sandwich,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Serializes this [CartItem] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'sandwich': {
        'type': sandwich.type.name,
        'isFootlong': sandwich.isFootlong,
        'breadType': sandwich.breadType.name,
      },
      'quantity': quantity,
    };
  }

  /// Creates a [CartItem] from a JSON map.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final sandwichJson = json['sandwich'] as Map<String, dynamic>;
    return CartItem(
      sandwich: Sandwich(
        type: SandwichType.values.byName(sandwichJson['type'] as String),
        isFootlong: sandwichJson['isFootlong'] as bool,
        breadType: BreadType.values.byName(sandwichJson['breadType'] as String),
      ),
      quantity: json['quantity'] as int,
    );
  }

  @override
  String toString() => 'CartItem(sandwich: $sandwich, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.quantity == quantity &&
        other.sandwich.type == sandwich.type &&
        other.sandwich.isFootlong == sandwich.isFootlong &&
        other.sandwich.breadType == sandwich.breadType;
  }

  @override
  int get hashCode {
    return Object.hash(
      sandwich.type,
      sandwich.isFootlong,
      sandwich.breadType,
      quantity,
    );
  }
}

/// Manages a collection of [CartItem]s.
///
/// Provides methods to add, remove, and update sandwich quantities,
/// and calculates total items and price.
class Cart {
  final PricingRepository _pricingRepository;
  final List<CartItem> _items = [];

  /// Creates a new cart.
  ///
  /// An optional [PricingRepository] can be provided for testing purposes.
  Cart({PricingRepository? pricingRepository})
      : _pricingRepository = pricingRepository ?? PricingRepository();

  /// A read-only view of the items in the cart.
  List<CartItem> get items => List.unmodifiable(_items);

  /// The total number of individual sandwiches in the cart (sums of quantities).
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  /// The total price of all items in the cart.
  ///
  /// Calculated using the injected [PricingRepository].
  double get totalPrice {
    return _items.fold(0.0, (total, item) {
      return total +
          _pricingRepository.calculatePrice(
            quantity: item.quantity,
            isFootlong: item.sandwich.isFootlong,
          );
    });
  }

  /// Finds the index of a [CartItem] in the cart that matches the given [sandwich].
  ///
  /// Returns -1 if no matching item is found.
  int _findItemIndex(Sandwich sandwich) {
    return _items.indexWhere((item) {
      final s = item.sandwich;
      return s.type == sandwich.type &&
          s.isFootlong == sandwich.isFootlong &&
          s.breadType == sandwich.breadType;
    });
  }

  /// Adds a [sandwich] to the cart.
  ///
  /// If the sandwich is already in the cart, its quantity is increased by the
  /// given [quantity] (default is 1). Otherwise, a new [CartItem] is added.
  /// Throws an [ArgumentError] if [quantity] is not positive.
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be a positive integer.');
    }

    final index = _findItemIndex(sandwich);

    if (index != -1) {
      final existingItem = _items[index];
      _items[index] =
          existingItem.copyWith(quantity: existingItem.quantity + quantity);
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes a [sandwich] from the cart.
  ///
  /// Decreases the quantity of the matching sandwich by the given [quantity]
  /// (default is 1). If the quantity drops to 0 or less, the item is
  /// completely removed from the cart.
  /// Throws an [ArgumentError] if [quantity] is not positive.
  void remove(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be a positive integer.');
    }

    final index = _findItemIndex(sandwich);

    if (index != -1) {
      final existingItem = _items[index];
      final newQuantity = existingItem.quantity - quantity;

      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = existingItem.copyWith(quantity: newQuantity);
      }
    }
  }

  /// Sets the exact [quantity] for a given [sandwich].
  ///
  /// If [quantity] is 0, the item is removed. If the item is not in the cart,
  /// it will be added with the specified quantity (if > 0).
  /// Throws an [ArgumentError] if [quantity] is negative.
  void setQuantity(Sandwich sandwich, int quantity) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }

    final index = _findItemIndex(sandwich);

    if (index != -1) {
      if (quantity == 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    } else if (quantity > 0) {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes all items from the cart.
  void clear() {
    _items.clear();
  }

  /// Serializes the cart to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
    };
  }

  /// Creates a [Cart] instance from a JSON map.
  factory Cart.fromJson(Map<String, dynamic> json) {
    final cart = Cart();
    if (json['items'] != null) {
      final items = json['items'] as List;
      for (final itemJson in items) {
        cart._items.add(CartItem.fromJson(itemJson as Map<String, dynamic>));
      }
    }
    return cart;
  }
}

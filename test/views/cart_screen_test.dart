import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  // Helper function to wrap widget with Provider and a cart with items
  Widget wrapWithProvider(Widget child, {List<Map<String, dynamic>>? items}) {
    return ChangeNotifierProvider<Cart>(
      create: (context) {
        final cart = Cart();
        if (items != null) {
          for (var item in items) {
            final sandwich = Sandwich(
              type: item['type'],
              isFootlong: item['isFootlong'],
              breadType: item['breadType'],
            );
            cart.add(sandwich, quantity: item['quantity']);
          }
        }
        return cart;
      },
      child: MaterialApp(home: child),
    );
  }

  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen));

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 2,
        }
      ]));

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('£22.00'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('has drawer menu button in app bar',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen));

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays cart counter in app bar',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 2,
        }
      ]));

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('shows checkout button when cart has items',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsOneWidget);
    });

    testWidgets('hides checkout button when cart is empty',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen));

      expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsNothing);
    });

    testWidgets('increment quantity button works correctly',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.text('Qty: 1'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add).first;
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Quantity increased'), findsOneWidget);
    });

    testWidgets('decrement quantity button works correctly',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 2,
        }
      ]));

      expect(find.text('Qty: 2'), findsOneWidget);

      final Finder removeButtonFinder = find.byIcon(Icons.remove).first;
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Quantity decreased'), findsOneWidget);
    });

    testWidgets('remove item button works correctly',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 2,
        }
      ]));

      expect(find.text('Veggie Delight'), findsOneWidget);

      final Finder deleteButtonFinder = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('drawer contains navigation items',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Find the drawer
      final drawerFinder = find.byType(Drawer);

      // Check drawer items scoped to the drawer
      expect(find.descendant(of: drawerFinder, matching: find.text('Order')),
          findsOneWidget);
      expect(find.descendant(of: drawerFinder, matching: find.text('Cart')),
          findsOneWidget);
      expect(find.descendant(of: drawerFinder, matching: find.text('Profile')),
          findsOneWidget);
      expect(find.descendant(of: drawerFinder, matching: find.text('Settings')),
          findsOneWidget);
    });

    testWidgets('cart counter updates when quantity changes',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.text('1'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add).first;
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });
  });
}

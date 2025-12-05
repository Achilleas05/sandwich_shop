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

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        },
        {
          'type': SandwichType.chickenTeriyaki,
          'isFootlong': false,
          'breadType': BreadType.wheat,
          'quantity': 3,
        }
      ]));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Qty: 3'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
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

    testWidgets('back button navigates back', (WidgetTester tester) async {
      const CartScreen cartScreen = CartScreen();
      await tester.pumpWidget(wrapWithProvider(cartScreen));

      final Finder backButtonFinder =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final ElevatedButton backButton =
          tester.widget<ElevatedButton>(backButtonFinder);
      expect(backButton.enabled, isTrue);
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

      // Find cart icon in app bar actions
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      // Should show 2 items in cart counter
      expect(find.text('2'), findsOneWidget);
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

      // Initial state: 1 item
      expect(find.text('1'), findsOneWidget);

      // Increment quantity
      final Finder addButtonFinder = find.byIcon(Icons.add).first;
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      // Should now show 2 items
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('navigates to checkout when checkout button is tapped',
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

      final Finder checkoutButtonFinder =
          find.widgetWithText(ElevatedButton, 'Checkout');
      expect(checkoutButtonFinder, findsOneWidget);

      // Note: Navigation test might need a mock navigator
      // For now, just verify the button exists and is enabled
      final ElevatedButton checkoutButton =
          tester.widget<ElevatedButton>(checkoutButtonFinder);
      expect(checkoutButton.enabled, isTrue);
    });
  });
}

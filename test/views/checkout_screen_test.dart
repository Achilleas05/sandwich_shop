import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
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

  group('CheckoutScreen', () {
    testWidgets('displays order summary with empty cart',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen));

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays order summary with single item',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 2,
        }
      ]));

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('displays order summary with multiple items',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
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

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
    });

    testWidgets('shows confirm payment button initially',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen));

      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Processing payment...'), findsNothing);
    });

    testWidgets('shows processing state when payment is initiated',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      final Finder confirmButtonFinder = find.text('Confirm Payment');
      await tester.tap(confirmButtonFinder);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsNothing);

      // Wait for the fake delay
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('calculates item prices correctly for footlong sandwiches',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget);
    });

    testWidgets('calculates item prices correctly for six-inch sandwiches',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': false,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('£7.00'), findsOneWidget);
    });

    testWidgets('displays correct total for mixed sandwich sizes',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
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
          'quantity': 2,
        }
      ]));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('2x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('payment method text is displayed correctly',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen));

      final Finder paymentMethodFinder =
          find.text('Payment Method: Card ending in 1234');
      expect(paymentMethodFinder, findsOneWidget);

      final Text paymentMethodText = tester.widget<Text>(paymentMethodFinder);
      expect(paymentMethodText.textAlign, equals(TextAlign.center));
    });

    testWidgets('order summary items are properly aligned',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      final Finder rowFinders = find.byType(Row);
      expect(rowFinders, findsWidgets);

      // Find the item row (with spaceBetween alignment)
      final itemRows = find.descendant(
        of: find.byType(Column),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.mainAxisAlignment == MainAxisAlignment.spaceBetween &&
              widget.children.any((child) =>
                  child is Text && (child as Text).data!.contains('x ')),
        ),
      );
      expect(itemRows, findsOneWidget);
    });

    testWidgets('displays divider between items and total',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('shows correct quantity and name format',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.chickenTeriyaki,
          'isFootlong': false,
          'breadType': BreadType.wheat,
          'quantity': 3,
        }
      ]));

      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('displays cart counter in app bar',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
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

    testWidgets('shows logo in app bar', (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen));

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows total with correct formatting',
        (WidgetTester tester) async {
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      await tester.pumpWidget(wrapWithProvider(checkoutScreen, items: [
        {
          'type': SandwichType.veggieDelight,
          'isFootlong': true,
          'breadType': BreadType.white,
          'quantity': 1,
        }
      ]));

      final Finder totalFinder = find.text('£11.00');
      expect(totalFinder, findsOneWidget);

      // Check the total row specifically
      final Finder totalRowFinder = find.widgetWithText(Row, 'Total:');
      expect(totalRowFinder, findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void dummyFunction() {}

void main() {
  // Helper function to wrap widget with Provider
  Widget wrapWithProvider(Widget child) {
    return ChangeNotifierProvider<Cart>(
      create: (context) => Cart(),
      child: MaterialApp(home: child),
    );
  }

  group('OrderScreen - Initial State', () {
    testWidgets('displays the initial UI elements correctly',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      expect(find.text('Sandwich Counter'), findsOneWidget);

      expect(find.byType(Image), findsAtLeast(1));

      expect(find.text('Veggie Delight'), findsWidgets);

      final Finder switchFinder = find.byType(Switch);
      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isTrue);

      expect(find.text('white'), findsWidgets);

      expect(find.text('1'), findsOneWidget);

      expect(
          find.widgetWithText(ElevatedButton, 'Add to Cart'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View Cart'), findsOneWidget);
    });

    testWidgets('displays cart counter in app bar',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      // Should show cart icon with 0 items initially
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('displays initial cart summary with zero items and price',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('updates cart summary when items are added to cart',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
    });

    testWidgets('updates cart summary when quantity is increased before adding',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('cart summary accumulates when multiple items are added',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('app bar cart counter updates when items are added',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      // Initial state
      expect(find.text('0'), findsOneWidget);

      // Add item
      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      // Should now show 1 item in cart counter
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('OrderScreen - Interactions', () {
    testWidgets('shows SnackBar confirmation when item is added to cart',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      const String expectedMessage =
          'Added 1 footlong Veggie Delight sandwich(es) on white bread to cart';

      expect(find.text(expectedMessage), findsOneWidget);
    });

    testWidgets('updates sandwich type when a new option is selected',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder sandwichDropdownFinder =
          find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdownFinder);
      await tester.pumpAndSettle();

      final Finder chickenTeriyakiOptionFinder =
          find.text('Chicken Teriyaki').last;
      await tester.tap(chickenTeriyakiOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('updates sandwich size when the switch is toggled',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pump();

      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isFalse);
    });

    testWidgets('updates bread type when a new option is selected',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder breadDropdownFinder = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdownFinder);
      await tester.pumpAndSettle();

      final Finder wheatOptionFinder = find.text('wheat').last;
      await tester.tap(wheatOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('increases quantity when add button is tapped',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decreases quantity when remove button is tapped',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      final Finder removeButtonFinder = find.byIcon(Icons.remove);
      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('quantity does not go below zero and buttons are disabled',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder removeButtonFinder =
          find.widgetWithIcon(IconButton, Icons.remove);
      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
      IconButton removeButton = tester.widget<IconButton>(removeButtonFinder);
      expect(removeButton.onPressed, isNull);

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      final ElevatedButton elevatedButton =
          tester.widget<ElevatedButton>(addToCartButtonFinder);
      expect(elevatedButton.enabled, isFalse);

      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('navigates to cart view when View Cart button is tapped',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder viewCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'View Cart');
      expect(viewCartButtonFinder, findsOneWidget);

      await tester.ensureVisible(viewCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart View'), findsOneWidget);
    });
  });

  // Note: Removed the StyledButton group since StyledButton is now just an ElevatedButton
  // If you want to test the custom button appearance, you can create separate tests
}

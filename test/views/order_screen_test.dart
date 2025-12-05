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

      // Changed from ElevatedButton to StyledButton
      expect(
          find.widgetWithText(ElevatedButton, 'Add to Cart'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View Cart'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Profile'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Settings'), findsOneWidget);
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

    testWidgets('navigates to profile when Profile button is tapped',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder profileButtonFinder =
          find.widgetWithText(ElevatedButton, 'Profile');
      expect(profileButtonFinder, findsOneWidget);

      await tester.ensureVisible(profileButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(profileButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('navigates to settings when Settings button is tapped',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder settingsButtonFinder =
          find.widgetWithText(ElevatedButton, 'Settings');
      expect(settingsButtonFinder, findsOneWidget);

      await tester.ensureVisible(settingsButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(settingsButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('StyledButton has correct styling properties',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder addToCartButtonFinder =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      final ElevatedButton button =
          tester.widget<ElevatedButton>(addToCartButtonFinder);

      // Check that it's an ElevatedButton (StyledButton extends ElevatedButton)
      expect(button, isA<ElevatedButton>());

      // Check button style
      expect(button.style?.backgroundColor?.resolve({}), equals(Colors.green));
      expect(button.style?.foregroundColor?.resolve({}), equals(Colors.white));

      // Check button has icon and text as children
      expect(
          find.descendant(
            of: addToCartButtonFinder,
            matching: find.byIcon(Icons.add_shopping_cart),
          ),
          findsOneWidget);
    });

    testWidgets('Settings button has correct styling',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      final Finder settingsButtonFinder =
          find.widgetWithText(ElevatedButton, 'Settings');
      final ElevatedButton button =
          tester.widget<ElevatedButton>(settingsButtonFinder);

      // Check button color
      expect(button.style?.backgroundColor?.resolve({}), equals(Colors.grey));

      // Check button has settings icon
      expect(
          find.descendant(
            of: settingsButtonFinder,
            matching: find.byIcon(Icons.settings),
          ),
          findsOneWidget);
    });

    testWidgets('shows welcome message after returning from profile',
        (WidgetTester tester) async {
      const OrderScreen orderScreen = OrderScreen();
      await tester.pumpWidget(wrapWithProvider(orderScreen));

      // Navigate to profile
      final Finder profileButtonFinder =
          find.widgetWithText(ElevatedButton, 'Profile');
      await tester.ensureVisible(profileButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(profileButtonFinder);
      await tester.pumpAndSettle();

      // Fill in profile details
      final Finder nameFieldFinder =
          find.widgetWithText(TextField, 'Your Name');
      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');
      final Finder saveButtonFinder = find.text('Save Profile');

      await tester.enterText(nameFieldFinder, 'John Doe');
      await tester.enterText(locationFieldFinder, 'London');
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Should show welcome message
      expect(
          find.text('Welcome, John Doe! Ordering from London'), findsOneWidget);
    });
  });

  group('StyledButton Widget Tests', () {
    testWidgets('StyledButton renders correctly when enabled',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isTrue);
    });

    testWidgets('StyledButton renders correctly when disabled',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isFalse);
    });
  });
}

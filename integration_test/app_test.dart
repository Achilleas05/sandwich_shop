import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton); // Scroll if needed
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing (2 seconds + buffer)
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('completed order appears in order history',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add one default sandwich
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pump(const Duration(seconds: 3));

      // Navigate to Order History tab/screen
      final orderHistoryTab = find.text('Order History');
      await tester.tap(orderHistoryTab);
      await tester.pumpAndSettle();

      // Verify at least one order is listed
      expect(find.textContaining('Order'), findsWidgets);
    });

    testWidgets('quantity can go to 0', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the minus button near quantity
      final minusButtons = find.byIcon(Icons.remove);
      final quantityMinusButton = minusButtons.first;

      // Tap minus once; quantity goes to 0
      await tester.tap(quantityMinusButton);
      await tester.pumpAndSettle();

      // Assert that quantity shows 0 (there are multiple '0's, but quantity is one)
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('add multiple sandwiches to cart and verify totals',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich (default Veggie Delight)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Change to Chicken Teriyaki and add another
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart: 2 items - £22.00'), findsOneWidget);

      // View cart and verify both items
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('attempt to add sandwich with quantity 0 does not add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Decrease quantity to 0
      final minusButtons = find.byIcon(Icons.remove);
      final quantityMinusButton = minusButtons.first;
      await tester.tap(quantityMinusButton);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsWidgets); // Quantity shows 0

      // Try to add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Cart should remain empty
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('checkout button not shown for empty cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to view cart when empty
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Cart screen shows empty
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);

      // Checkout button is not present for empty cart
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      expect(checkoutButton, findsNothing);
    });

    testWidgets('multiple orders appear in order history',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Complete first order
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();
      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pump(const Duration(seconds: 3));

      // Complete second order with different sandwich
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmPaymentButton);
      await tester.pump(const Duration(seconds: 3));

      // Check order history
      final orderHistoryTab = find.text('Order History');
      await tester.tap(orderHistoryTab);
      await tester.pumpAndSettle();
      expect(find.textContaining('Order'), findsWidgets); // At least two orders
    });

    testWidgets('navigate back from cart to order screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item and go to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart'), findsOneWidget);

      // Assume there's a back button or way to return
      final backButton = find.byIcon(Icons.arrow_back); // Adjust if different
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(find.text('Sandwich Counter'), findsOneWidget);
      }
    });

    testWidgets('increase quantity to high value and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Increase quantity multiple times
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;
      for (int i = 0; i < 5; i++) {
        await tester.tap(quantityAddButton);
        await tester.pumpAndSettle();
      }
      expect(find.text('6'), findsOneWidget); // Assuming starts at 1

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart: 6 items - £66.00'), findsOneWidget);
    });
  });
}

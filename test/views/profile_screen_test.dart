import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  // Helper function to wrap widget with Provider
  Widget wrapWithProvider(Widget child) {
    return ChangeNotifierProvider<Cart>(
      create: (context) => Cart(),
      child: MaterialApp(home: child),
    );
  }

  group('ProfileScreen', () {
    testWidgets('displays initial UI elements correctly',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      expect(find.text('Profile'), findsNWidgets(2));
      expect(find.text('Enter your details:'), findsOneWidget);
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Preferred Location'), findsOneWidget);
      expect(find.text('Save Profile'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has drawer menu button in app bar',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays cart counter in app bar',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('text fields accept input correctly',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      final Finder nameFieldFinder =
          find.widgetWithText(TextField, 'Your Name');
      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');

      await tester.enterText(nameFieldFinder, 'John Doe');
      await tester.enterText(locationFieldFinder, 'London');
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('shows validation error when name field is empty',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');
      final Finder saveButtonFinder = find.text('Save Profile');

      await tester.enterText(locationFieldFinder, 'London');
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('drawer contains navigation items',
        (WidgetTester tester) async {
      const ProfileScreen profileScreen = ProfileScreen();
      await tester.pumpWidget(wrapWithProvider(profileScreen));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Check drawer items
      expect(
          find.descendant(
              of: find.byType(Drawer), matching: find.text('Order')),
          findsOneWidget);
      expect(
          find.descendant(of: find.byType(Drawer), matching: find.text('Cart')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(Drawer), matching: find.text('Profile')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(Drawer), matching: find.text('Settings')),
          findsOneWidget);
    });

    testWidgets('returns profile data when both fields are filled',
        (WidgetTester tester) async {
      Map<String, String>? result;

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute<Map<String, String>>(
                          builder: (BuildContext context) =>
                              const ProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Go to Profile'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      final Finder nameFieldFinder =
          find.widgetWithText(TextField, 'Your Name');
      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');
      final Finder saveButtonFinder = find.text('Save Profile');

      await tester.enterText(nameFieldFinder, 'Jane Smith');
      await tester.enterText(locationFieldFinder, 'Manchester');
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['name'], equals('Jane Smith'));
      expect(result!['location'], equals('Manchester'));
    });
  });
}

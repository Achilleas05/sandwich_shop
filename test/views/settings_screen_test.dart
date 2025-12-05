import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Mock SharedPreferences
  setUp(() {
    SharedPreferences.setMockInitialValues({'fontSize': 16.0});
  });

  // Helper function to wrap widget with Provider
  Widget wrapWithProvider(Widget child) {
    return ChangeNotifierProvider<Cart>(
      create: (context) => Cart(),
      child: MaterialApp(home: child),
    );
  }

  group('SettingsScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('displays UI elements after loading',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('Current size: 16px'), findsOneWidget);
      expect(
          find.text(
              'Font size changes are saved automatically. Restart the app to see changes in all screens.'),
          findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
    });

    testWidgets('has drawer menu button in app bar',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays cart counter in app bar',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('contains a slider for font size adjustment',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
      expect(slider.value, equals(16.0));
    });

    testWidgets('drawer contains navigation items',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Check drawer items
      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('loading completes and shows UI', (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      await tester.pumpWidget(wrapWithProvider(settingsScreen));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Slider), findsNothing);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
    });
  });
}

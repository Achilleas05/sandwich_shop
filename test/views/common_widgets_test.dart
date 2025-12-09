import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
// Assuming this is accessible

void main() {
  group('buildNavigationItems', () {
    testWidgets('returns 4 ListTiles with correct titles and icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: Builder(
                  builder: (context) =>
                      Column(children: buildNavigationItems(context))))));
      expect(find.byType(ListTile), findsNWidgets(4));
      expect(find.text('Order'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('MainAppBar', () {
    testWidgets('renders title and cart counter on small screen',
        (WidgetTester tester) async {
      final cart = Cart();
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
              home: Scaffold(appBar: MainAppBar(title: 'Test'))),
        ),
      );
      expect(find.text('Test'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Assuming cart starts empty
    });

    testWidgets('shows navigation buttons on large screen',
        (WidgetTester tester) async {
      final cart = Cart();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: ChangeNotifierProvider<Cart>.value(
            value: cart,
            child: const MaterialApp(
                home: Scaffold(appBar: MainAppBar(title: 'Test'))),
          ),
        ),
      );
      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('buildAppDrawer', () {
    testWidgets('renders Drawer with header and navigation items',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Builder(builder: (context) => buildAppDrawer(context))));
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(4));
    });
  });

  group('StyledButton', () {
    testWidgets('renders icon, label, and calls onPressed',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: StyledButton(
            onPressed: () => pressed = true,
            icon: Icons.add,
            label: 'Add',
            backgroundColor: Colors.blue,
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, true);
    });
  });
}

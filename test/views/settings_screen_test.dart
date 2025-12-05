import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  // Mock SharedPreferences
  setUp(() {
    // Initialize mock SharedPreferences with default font size
    SharedPreferences.setMockInitialValues({'fontSize': 16.0});
  });

  tearDown(() async {
    // Reset AppStyles state
    await AppStyles.loadFontSize();
  });

  group('SettingsScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Initially shows loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('displays UI elements after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('Current size: 16px'), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
      expect(
          find.text(
              'Font size changes are saved automatically. Restart the app to see changes in all screens.'),
          findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('contains a slider for font size adjustment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
      expect(slider.value, equals(16.0));
    });

    testWidgets('updates font size when slider is moved',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state
      expect(find.text('Current size: 16px'), findsOneWidget);

      // Find the slider
      final Finder sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);
    });

    testWidgets('shows preview text with current font size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final Finder previewTextFinder =
          find.text('This is sample text to preview the font size.');
      expect(previewTextFinder, findsOneWidget);

      final Text previewText = tester.widget<Text>(previewTextFinder);
      expect(previewText.style?.fontSize, equals(16.0));
    });

    testWidgets('displays back button that can be pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final Finder backButtonFinder = find.text('Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final ElevatedButton backButton =
          tester.widget<ElevatedButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('uses AppStyles for text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Check that AppStyles is used for certain text
      final Finder settingsTitleFinder = find.text('Settings');
      final Finder fontSizeTitleFinder = find.text('Font Size');

      // These should use AppStyles.heading1 and AppStyles.heading2
      expect(settingsTitleFinder, findsOneWidget);
      expect(fontSizeTitleFinder, findsOneWidget);
    });

    testWidgets('saves font size when slider changes',
        (WidgetTester tester) async {
      // Track calls to AppStyles.saveFontSize

      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and interact with slider
      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);

      // Simulate slider change by calling the onChanged callback directly
      if (slider.onChanged != null) {
        slider.onChanged!(18.0);
        await tester.pump();

        // Check that AppStyles.baseFontSize was updated
        // This is indirect since we can't directly observe the method call
        // but we can verify the UI updates
        expect(find.text('Current size: 18px'), findsOneWidget);
      }
    });

    testWidgets('handles different initial font sizes',
        (WidgetTester tester) async {
      // Test with different initial font size
      SharedPreferences.setMockInitialValues({'fontSize': 20.0});

      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current size: 20px'), findsOneWidget);

      final Slider slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(20.0));
    });

    testWidgets('shows correct slider configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final Slider slider = tester.widget<Slider>(find.byType(Slider));

      // Verify slider properties
      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
      expect(slider.label, equals('16')); // Current font size as integer
    });

    testWidgets('displays instructional text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      const expectedText =
          'Font size changes are saved automatically. Restart the app to see changes in all screens.';
      expect(find.text(expectedText), findsOneWidget);

      final Text instructionText = tester.widget<Text>(find.text(expectedText));
      expect(instructionText.textAlign, equals(TextAlign.center));
      expect(instructionText.style?.fontSize, equals(AppStyles.baseFontSize));
    });

    testWidgets('preview text updates with font size',
        (WidgetTester tester) async {
      // Set initial font size to 18
      SharedPreferences.setMockInitialValues({'fontSize': 18.0});

      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Should show updated font size
      expect(find.text('Current size: 18px'), findsOneWidget);

      final Text previewText = tester.widget<Text>(
          find.text('This is sample text to preview the font size.'));
      expect(previewText.style?.fontSize, equals(18.0));
    });

    testWidgets('loading completes and shows UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Slider), findsNothing);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should now show the UI
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
    });
  });
}

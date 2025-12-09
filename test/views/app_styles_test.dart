import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Reset mock SharedPreferences for each test
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    // Reset baseFontSize to default after each test
    await AppStyles.saveFontSize(16.0);
  });

  group('AppStyles', () {
    test('initial baseFontSize should be 16.0', () {
      expect(AppStyles.baseFontSize, 16.0);
    });

    test('loadFontSize should set baseFontSize from prefs or default to 16.0',
        () async {
      // Test default
      await AppStyles.loadFontSize();
      expect(AppStyles.baseFontSize, 16.0);

      // Test loaded value
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSize', 20.0);
      await AppStyles.loadFontSize();
      expect(AppStyles.baseFontSize, 20.0);
    });

    test('saveFontSize should persist and update baseFontSize', () async {
      await AppStyles.saveFontSize(18.0);
      expect(AppStyles.baseFontSize, 18.0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('fontSize'), 18.0);
    });

    test('normalText should return TextStyle with baseFontSize', () {
      expect(AppStyles.normalText.fontSize, 16.0);
      expect(AppStyles.normalText.fontWeight, isNull);
    });

    test('heading1 should return TextStyle with larger size and bold', () {
      expect(AppStyles.heading1.fontSize, 24.0);
      expect(AppStyles.heading1.fontWeight, FontWeight.bold);
    });

    test('heading2 should return TextStyle with medium size and bold', () {
      expect(AppStyles.heading2.fontSize, 20.0);
      expect(AppStyles.heading2.fontWeight, FontWeight.bold);
    });

    test('global getters should match AppStyles getters', () {
      expect(normalText, AppStyles.normalText);
      expect(heading1, AppStyles.heading1);
      expect(heading2, AppStyles.heading2);
    });
  });
}

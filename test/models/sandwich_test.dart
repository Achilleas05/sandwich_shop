import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns correct name for each SandwichType', () {
      expect(
        Sandwich(
                type: SandwichType.veggieDelight,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Veggie Delight',
      );
      expect(
        Sandwich(
                type: SandwichType.chickenTeriyaki,
                isFootlong: false,
                breadType: BreadType.wheat)
            .name,
        'Chicken Teriyaki',
      );
      expect(
        Sandwich(
                type: SandwichType.tunaMelt,
                isFootlong: true,
                breadType: BreadType.wholemeal)
            .name,
        'Tuna Melt',
      );
      expect(
        Sandwich(
                type: SandwichType.meatballMarinara,
                isFootlong: false,
                breadType: BreadType.white)
            .name,
        'Meatball Marinara',
      );
    });

    test('image getter returns correct path for type and size', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(sandwich.image, 'assets/images/veggieDelight_footlong.png');

      final sandwichSmall = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(sandwichSmall.image, 'assets/images/tunaMelt_six_inch.png');
    });

    test('breadType and type enums restrict values', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(sandwich.type, SandwichType.chickenTeriyaki);
      expect(sandwich.breadType, BreadType.wholemeal);
      expect(SandwichType.values.length, 4);
      expect(BreadType.values.length, 3);
    });
  });
}

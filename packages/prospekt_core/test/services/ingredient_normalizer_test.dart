import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_core/prospekt_core.dart';

void main() {
  late IngredientNormalizer normalizer;

  setUp(() {
    normalizer = IngredientNormalizer();
  });

  group('IngredientNormalizer', () {
    test('normalizes marketing variants to base ingredients', () {
      expect(normalizer.normalize('Bio Speisekartoffeln'), 'Kartoffel');
      expect(normalizer.normalize('Netz Kartoffeln 5kg'), 'Kartoffel');
      expect(normalizer.normalize('Rinderhackfleisch'), 'Hackfleisch');
      expect(normalizer.normalize('Gemischtes Hack'), 'Hackfleisch');
      expect(normalizer.normalize('Schlagsahne 250ml'), 'Sahne');
      expect(normalizer.normalize('Gouda Käse'), 'Käse');
    });

    test('identifies ready meals correctly', () {
      expect(normalizer.isReadyMeal('Dr. Oetker Ristorante Pizza'), true);
      expect(normalizer.isReadyMeal('Fertiglasagne'), true);
      expect(normalizer.isReadyMeal('Rahmspinat mit Blubb'), true);
      expect(normalizer.isReadyMeal('Kartoffeln'), false);
    });

    test('normalizes ready meals to their meal type', () {
      expect(normalizer.normalize('Pizza Salami'), 'Pizza');
      expect(normalizer.normalize('Hausmacher Lasagne'), 'Lasagne');
    });

    test('returns raw name if no normalization matches', () {
      expect(normalizer.normalize('Exotische Drachenfrucht'), 'Exotische Drachenfrucht');
    });
  });
}

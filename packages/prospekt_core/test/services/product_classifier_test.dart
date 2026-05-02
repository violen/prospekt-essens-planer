import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_core/prospekt_core.dart';

void main() {
  late ProductClassifier classifier;

  setUp(() {
    classifier = ProductClassifier();
  });

  group('ProductClassifier', () {
    test('identifies drinks correctly', () {
      expect(classifier.classify('Coca Cola 1,5L'), ProductCategory.drink);
      expect(classifier.classify('Kasten Beck\'s Pils'), ProductCategory.drink);
      expect(classifier.classify('Red Bull Energy'), ProductCategory.drink);
      expect(classifier.classify('Mineralwasser Medium'), ProductCategory.drink);
    });

    test('identifies non-food items correctly', () {
      expect(classifier.classify('Ariel Waschmittel', '80 WL'), ProductCategory.nonFood);
      expect(classifier.classify('Toilettenpapier 3-lagig', '8 Rollen'), ProductCategory.nonFood);
      expect(classifier.classify('Tefal Pfanne 28cm'), ProductCategory.nonFood);
      expect(classifier.classify('Hundefutter Mix'), ProductCategory.nonFood);
    });

    test('identifies food items correctly (whitelist & ingredients)', () {
      expect(classifier.classify('Frisches Hackfleisch gemischt'), ProductCategory.food);
      expect(classifier.classify('Bio Speisekartoffeln'), ProductCategory.food);
      expect(classifier.classify('Gouda Käse am Stück'), ProductCategory.food);
      expect(classifier.classify('Spaghetti Nudeln'), ProductCategory.food);
      expect(classifier.classify('Überraschungsei'), ProductCategory.food);
    });

    test('returns unknown for ambiguous items', () {
      expect(classifier.classify('Dingsbums'), ProductCategory.unknown);
    });
  });
}

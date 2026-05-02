import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_core/prospekt_core.dart';

void main() {
  late MatchingService matchingService;

  setUp(() {
    matchingService = MatchingService();
  });

  group('MatchingService', () {
    test('matchRecipe finds matches and calculates savings', () {
      final recipe = Recipe(name: 'Omelett', isConvenience: false, rating: 0);
      final ingredients = [
        RecipeIngredient(name: 'Eier', recipeId: 1, amount: 4),
        RecipeIngredient(name: 'Milch', recipeId: 1, amount: 0.1),
      ];
      final offers = [
        Offer(id: 1, brochureId: 1, productName: 'Bio Eier 10er', price: 2.99),
      ];

      final summary = matchingService.matchRecipe(recipe, ingredients, offers);
      
      expect(summary.ingredientMatches.length, 2);
      expect(summary.ingredientMatches[0].isMatch, true);
      expect(summary.ingredientMatches[1].isMatch, false);
      expect(summary.totalCurrentPrice, greaterThan(0));
      expect(summary.totalSavings, greaterThan(0));
    });

    test('calculates correct match rate in summary', () {
      final recipe = Recipe(name: 'Test', isConvenience: false, rating: 0);
      final ingredients = [
        RecipeIngredient(name: 'A', recipeId: 1),
        RecipeIngredient(name: 'B', recipeId: 1),
      ];
      final offers = [
        Offer(id: 1, brochureId: 1, productName: 'A', price: 1.0),
      ];

      final summary = matchingService.matchRecipe(recipe, ingredients, offers);
      expect(summary.matchRate, 0.5);
    });
  });
}

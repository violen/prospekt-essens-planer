import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_core/prospekt_core.dart';

void main() {
  late ScoringService scoringService;

  setUp(() {
    scoringService = ScoringService();
  });

  group('ScoringService', () {
    test('ranks recipes with higher match rate first', () {
      final recipeA = Recipe(name: 'A', isConvenience: false, rating: 0);
      final recipeB = Recipe(name: 'B', isConvenience: false, rating: 0);
      
      final summaryA = RecipeMatchSummary(
        recipe: recipeA,
        ingredientMatches: [
          MatchResult(ingredient: RecipeIngredient(name: 'X', recipeId: 1), confidence: 0),
        ],
        totalCurrentPrice: 10,
        totalEstimatedStandardPrice: 10,
      ); // Match rate 0.0

      final summaryB = RecipeMatchSummary(
        recipe: recipeB,
        ingredientMatches: [
          MatchResult(ingredient: RecipeIngredient(name: 'X', recipeId: 2), confidence: 1.0, matchedOffer: Offer(id: 1, brochureId: 1, productName: 'X', price: 5)),
        ],
        totalCurrentPrice: 5,
        totalEstimatedStandardPrice: 10,
      ); // Match rate 1.0

      final ranked = scoringService.rankRecipes([summaryA, summaryB]);
      
      expect(ranked.first.recipe.name, 'B');
    });

    test('ranks recipes with higher rating first if match rate is equal', () {
      final recipeA = Recipe(name: 'Low Rating', isConvenience: false, rating: 1);
      final recipeB = Recipe(name: 'High Rating', isConvenience: false, rating: 5);
      
      final summaryA = RecipeMatchSummary(
        recipe: recipeA,
        ingredientMatches: [],
        totalCurrentPrice: 0,
        totalEstimatedStandardPrice: 0,
      );

      final summaryB = RecipeMatchSummary(
        recipe: recipeB,
        ingredientMatches: [],
        totalCurrentPrice: 0,
        totalEstimatedStandardPrice: 0,
      );

      final ranked = scoringService.rankRecipes([summaryA, summaryB]);
      
      expect(ranked.first.recipe.name, 'High Rating');
    });
  });
}

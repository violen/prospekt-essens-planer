import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';
import 'meal_planner_state.dart';

final mealPlannerControllerProvider = StateNotifierProvider<MealPlannerController, MealPlannerState>((ref) {
  return MealPlannerController(ref);
});

class MealPlannerController extends StateNotifier<MealPlannerState> {
  final Ref _ref;

  MealPlannerController(this._ref) : super(MealPlannerState(status: MealPlannerStatus.loading)) {
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    state = state.copyWith(status: MealPlannerStatus.loading);

    try {
      final recipeRepo = _ref.read(recipeRepositoryProvider);
      final offerRepo = _ref.read(offerRepositoryProvider);
      final brochureRepo = _ref.read(brochureRepositoryProvider);
      final matchingService = _ref.read(matchingServiceProvider);
      final scoringService = _ref.read(scoringServiceProvider);

      // 1. Fetch all recipes
      final recipes = await recipeRepo.getAllRecipes();
      
      // 2. Fetch current offers (from all active brochures)
      // For simplicity, we fetch all offers. In a real app, we might filter by date.
      final brochures = await brochureRepo.getAllBrochures();
      final allOffers = <Offer>[];
      for (final brochure in brochures) {
        if (brochure.status == 'completed' || brochure.status == 'pending') {
          final offers = await offerRepo.getOffersByBrochureId(brochure.id!);
          allOffers.addAll(offers);
        }
      }

      // 3. Match each recipe
      final summaries = <RecipeMatchSummary>[];
      for (final recipe in recipes) {
        final ingredients = await recipeRepo.getIngredientsForRecipe(recipe.id!);
        final summary = matchingService.matchRecipe(recipe, ingredients, allOffers);
        summaries.add(summary);
      }

      // 3.1. Match Fix-products (Convenience Library)
      for (final fixProduct in FixProductLibrary.products) {
        final virtualRecipe = fixProduct.toRecipe();
        final virtualIngredients = fixProduct.toIngredients(-1); // Dummy ID
        final summary = matchingService.matchRecipe(virtualRecipe, virtualIngredients, allOffers);
        
        // Only suggest if at least one ingredient is on offer or if user has many ingredients already
        if (summary.matchRate > 0) {
          summaries.add(summary);
        }
      }

      // 3.2. Identify and Suggest Ready Meals (Direct matches)
      final seenReadyMeals = <String>{};
      for (final offer in allOffers) {
        if (offer.isReadyMeal == true && offer.normalizedName != null) {
          final mealName = offer.normalizedName!;
          if (seenReadyMeals.contains(mealName)) continue;
          
          final virtualRecipe = Recipe(
            id: -2, // Virtual ID for ready meals
            name: mealName,
            isConvenience: true,
            rating: 4, // Prioritize ready meals slightly
          );
          
          final virtualIngredient = RecipeIngredient(name: mealName, recipeId: -2);
          
          final summary = RecipeMatchSummary(
            recipe: virtualRecipe,
            ingredientMatches: [
              MatchResult(
                ingredient: virtualIngredient,
                matchedOffer: offer,
                confidence: 1.0,
                estimatedStandardPrice: offer.price * 1.5, // Heuristic: 50% savings
              ),
            ],
            totalCurrentPrice: offer.price,
            totalEstimatedStandardPrice: offer.price * 1.5,
            canUseConvenience: true,
          );
          
          summaries.add(summary);
          seenReadyMeals.add(mealName);
        }
      }

      // 4. Rank by preferences
      final ranked = scoringService.rankRecipes(summaries);

      state = state.copyWith(
        status: MealPlannerStatus.success,
        recommendations: ranked,
      );
    } catch (e) {
      state = state.copyWith(status: MealPlannerStatus.error, errorMessage: e.toString());
    }
  }
}

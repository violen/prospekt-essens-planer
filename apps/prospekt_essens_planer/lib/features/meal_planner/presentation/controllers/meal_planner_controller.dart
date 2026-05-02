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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';

class RecipeState {
  final List<Recipe> recipes;
  final List<String> availableIngredients;
  final bool isLoading;
  final String? errorMessage;

  RecipeState({
    this.recipes = const [], 
    this.availableIngredients = const [],
    this.isLoading = false, 
    this.errorMessage,
  });

  RecipeState copyWith({
    List<Recipe>? recipes, 
    List<String>? availableIngredients,
    bool? isLoading, 
    String? errorMessage,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      availableIngredients: availableIngredients ?? this.availableIngredients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final recipeControllerProvider = StateNotifierProvider<RecipeController, RecipeState>((ref) {
  return RecipeController(ref);
});

class RecipeController extends StateNotifier<RecipeState> {
  final Ref _ref;

  RecipeController(this._ref) : super(RecipeState()) {
    _init();
  }

  Future<void> _init() async {
    await loadRecipes();
    await loadAvailableIngredients();
  }

  Future<void> loadRecipes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(recipeRepositoryProvider);
      final recipes = await repo.getAllRecipes();
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadAvailableIngredients() async {
    try {
      final offerRepo = _ref.read(offerRepositoryProvider);
      final names = await offerRepo.getUniqueProductNames();
      state = state.copyWith(availableIngredients: names);
    } catch (e) {
      // Non-blocking error for autocomplete
    }
  }

  Future<void> addRecipe(String name, bool isConvenience, List<String> ingredients) async {
    try {
      final repo = _ref.read(recipeRepositoryProvider);
      
      final recipeIngredients = ingredients.map((ing) => RecipeIngredient(
        name: ing,
        recipeId: 0, // Will be set by repo transaction
      )).toList();

      await repo.insertRecipe(
        Recipe(name: name, isConvenience: isConvenience, rating: 0),
        recipeIngredients,
      );
      await loadRecipes();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      final repo = _ref.read(recipeRepositoryProvider);
      await repo.deleteRecipe(id);
      await loadRecipes();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

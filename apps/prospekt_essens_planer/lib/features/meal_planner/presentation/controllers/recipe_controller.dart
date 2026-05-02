import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';

class RecipeState {
  final List<Recipe> recipes;
  final bool isLoading;
  final String? errorMessage;

  RecipeState({this.recipes = const [], this.isLoading = false, this.errorMessage});

  RecipeState copyWith({List<Recipe>? recipes, bool? isLoading, String? errorMessage}) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
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
    loadRecipes();
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

  Future<void> addRecipe(String name, bool isConvenience) async {
    try {
      final repo = _ref.read(recipeRepositoryProvider);
      await repo.insertRecipe(
        Recipe(name: name, isConvenience: isConvenience, rating: 0),
        [],
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';

class RecipeState {
  final List<Recipe> recipes;
  final bool isLoading;

  RecipeState({this.recipes = const [], this.isLoading = false});

  RecipeState copyWith({List<Recipe>? recipes, bool? isLoading}) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
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
    state = state.copyWith(isLoading: true);
    final repo = _ref.read(recipeRepositoryProvider);
    final recipes = await repo.getAllRecipes();
    state = state.copyWith(recipes: recipes, isLoading: false);
  }

  Future<void> addRecipe(String name, bool isConvenience) async {
    final repo = _ref.read(recipeRepositoryProvider);
    await repo.insertRecipe(
      Recipe(name: name, isConvenience: isConvenience, rating: 0),
      [],
    );
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    final repo = _ref.read(recipeRepositoryProvider);
    await repo.deleteRecipe(id);
    await loadRecipes();
  }
}

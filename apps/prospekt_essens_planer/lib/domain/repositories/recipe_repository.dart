import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getAllRecipes();
  Future<Recipe> getRecipeById(int id);
  Future<List<RecipeIngredient>> getIngredientsForRecipe(int recipeId);
  Future<int> insertRecipe(Recipe recipe, List<RecipeIngredient> ingredients);
  Future<void> updateRecipeRating(int id, int rating);
  Future<void> deleteRecipe(int id);
}

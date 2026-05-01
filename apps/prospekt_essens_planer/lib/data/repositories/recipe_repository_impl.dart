import 'package:drift/drift.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../local/database.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final AppDatabase db;

  RecipeRepositoryImpl(this.db);

  @override
  Future<List<Recipe>> getAllRecipes() async {
    final rows = await db.select(db.recipes).get();
    return rows.map((row) => _mapRecipeToEntity(row)).toList();
  }

  @override
  Future<Recipe> getRecipeById(int id) async {
    final query = db.select(db.recipes)..where((t) => t.id.equals(id));
    final row = await query.getSingle();
    return _mapRecipeToEntity(row);
  }

  @override
  Future<List<RecipeIngredient>> getIngredientsForRecipe(int recipeId) async {
    final query = db.select(db.recipeIngredients)
      ..where((t) => t.recipeId.equals(recipeId));
    final rows = await query.get();
    return rows.map((row) => _mapIngredientToEntity(row)).toList();
  }

  @override
  Future<int> insertRecipe(Recipe recipe, List<RecipeIngredient> ingredients) async {
    return await db.transaction(() async {
      final recipeId = await db.into(db.recipes).insert(
            RecipesCompanion.insert(
              name: recipe.name,
              instructions: Value(recipe.instructions),
              isConvenience: Value(recipe.isConvenience),
              rating: Value(recipe.rating),
            ),
          );

      for (final ingredient in ingredients) {
        await db.into(db.recipeIngredients).insert(
              RecipeIngredientsCompanion.insert(
                recipeId: recipeId,
                name: ingredient.name,
                amount: Value(ingredient.amount),
                unit: Value(ingredient.unit),
              ),
            );
      }

      return recipeId;
    });
  }

  @override
  Future<void> updateRecipeRating(int id, int rating) async {
    final query = db.update(db.recipes)..where((t) => t.id.equals(id));
    await query.write(RecipesCompanion(rating: Value(rating)));
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await db.transaction(() async {
      final deleteIngredients = db.delete(db.recipeIngredients)
        ..where((t) => t.recipeId.equals(id));
      await deleteIngredients.go();

      final deleteRecipe = db.delete(db.recipes)..where((t) => t.id.equals(id));
      await deleteRecipe.go();
    });
  }

  Recipe _mapRecipeToEntity(RecipeEntry row) {
    return Recipe(
      id: row.id,
      name: row.name,
      instructions: row.instructions,
      isConvenience: row.isConvenience,
      rating: row.rating,
    );
  }

  RecipeIngredient _mapIngredientToEntity(RecipeIngredientEntry row) {
    return RecipeIngredient(
      id: row.id,
      recipeId: row.recipeId,
      name: row.name,
      amount: row.amount,
      unit: row.unit,
    );
  }
}

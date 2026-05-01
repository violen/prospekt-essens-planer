import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_essens_planer/data/local/database.dart';
import 'package:prospekt_essens_planer/data/repositories/recipe_repository_impl.dart';
import 'package:prospekt_essens_planer/domain/entities/recipe.dart';

void main() {
  late AppDatabase database;
  late RecipeRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = RecipeRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('can insert and retrieve a recipe with ingredients', () async {
    final recipe = Recipe(
      id: 0,
      name: 'Kartoffelauflauf',
      instructions: 'Backen...',
      isConvenience: false,
      rating: 5,
    );
    final ingredients = [
      RecipeIngredient(id: 0, recipeId: 0, name: 'Kartoffeln', amount: 1, unit: 'kg'),
      RecipeIngredient(id: 0, recipeId: 0, name: 'Sahne', amount: 200, unit: 'ml'),
    ];

    final id = await repository.insertRecipe(recipe, ingredients);
    final retrievedRecipe = await repository.getRecipeById(id);
    final retrievedIngredients = await repository.getIngredientsForRecipe(id);

    expect(retrievedRecipe.name, 'Kartoffelauflauf');
    expect(retrievedIngredients.length, 2);
    expect(retrievedIngredients.any((i) => i.name == 'Kartoffeln'), true);
  });
}

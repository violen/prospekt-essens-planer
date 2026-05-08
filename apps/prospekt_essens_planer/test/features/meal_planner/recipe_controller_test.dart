import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_essens_planer/core/providers.dart';
import 'package:prospekt_core/prospekt_core.dart';
import 'package:prospekt_data/prospekt_data.dart';
import 'package:prospekt_essens_planer/features/meal_planner/presentation/controllers/recipe_controller.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        recipeRepositoryProvider.overrideWithValue(RecipeRepositoryImpl(database)),
        offerRepositoryProvider.overrideWithValue(OfferRepositoryImpl(database)),
      ],
    );
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  test('addRecipe correctly maps ingredients and saves them', () async {
    final controller = container.read(recipeControllerProvider.notifier);
    
    const recipeName = 'Kartoffelgratin';
    final ingredients = ['Kartoffeln', 'Sahne', 'Käse'];

    await controller.addRecipe(recipeName, false, ingredients);

    // Verify state
    final state = container.read(recipeControllerProvider);
    expect(state.recipes.length, 1);
    expect(state.recipes.first.name, recipeName);

    // Verify DB
    final repo = container.read(recipeRepositoryProvider);
    final savedIngredients = await repo.getIngredientsForRecipe(state.recipes.first.id!);
    
    expect(savedIngredients.length, 3);
    expect(savedIngredients.map((i) => i.name), containsAll(ingredients));
  });

  test('loadAvailableIngredients populates state from market data', () async {
    final offerRepo = container.read(offerRepositoryProvider);
    await offerRepo.insertOffer(Offer(id: 0, brochureId: 1, productName: 'Bio Kartoffeln', normalizedName: 'Kartoffel', price: 1.0));
    await offerRepo.insertOffer(Offer(id: 0, brochureId: 1, productName: 'Gouda', normalizedName: 'Käse', price: 2.0));

    final controller = container.read(recipeControllerProvider.notifier);
    await controller.loadAvailableIngredients();

    final state = container.read(recipeControllerProvider);
    expect(state.availableIngredients, containsAll(['Kartoffel', 'Käse']));
  });
}

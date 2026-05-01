import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/repositories/brochure_repository_impl.dart';
import '../data/repositories/meal_plan_repository_impl.dart';
import '../data/repositories/offer_repository_impl.dart';
import '../data/repositories/pdf_brochure_parser.dart';
import '../data/repositories/recipe_repository_impl.dart';
import '../domain/repositories/brochure_parser.dart';
import '../domain/repositories/brochure_repository.dart';
import '../domain/repositories/meal_plan_repository.dart';
import '../domain/repositories/offer_repository.dart';
import '../domain/repositories/recipe_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final brochureRepositoryProvider = Provider<BrochureRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BrochureRepositoryImpl(db);
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfferRepositoryImpl(db);
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RecipeRepositoryImpl(db);
});

final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MealPlanRepositoryImpl(db);
});

final brochureParserProvider = Provider<BrochureParser>((ref) {
  return PdfBrochureParser();
});


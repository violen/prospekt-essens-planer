import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import 'package:prospekt_data/prospekt_data.dart';

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

final pdfBrochureParserProvider = Provider<PdfBrochureParser>((ref) {
  return PdfBrochureParser();
});

final ocrBrochureParserProvider = Provider<OcrBrochureParser>((ref) {
  final parser = OcrBrochureParser();
  ref.onDispose(() => parser.dispose());
  return parser;
});

final brochureParserProvider = Provider<BrochureParser>((ref) {
  return CompositeBrochureParser(
    ref.watch(pdfBrochureParserProvider),
    ref.watch(ocrBrochureParserProvider),
  );
});

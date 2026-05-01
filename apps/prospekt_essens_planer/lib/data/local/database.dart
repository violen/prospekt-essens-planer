import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('BrochureEntry')
class Brochures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get filePath => text()();
  DateTimeColumn get importDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, processing, completed, error
}

@DataClassName('OfferEntry')
class Offers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get brochureId => integer().references(Brochures, #id)();
  TextColumn get productName => text().withLength(min: 1, max: 255)();
  RealColumn get price => real()();
  TextColumn get unit => text().nullable()(); // e.g., "kg", "Stück", "Packung"
  TextColumn get discountInfo => text().nullable()();
  TextColumn get category => text().nullable()();
}

@DataClassName('RecipeEntry')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get instructions => text().nullable()();
  BoolColumn get isConvenience => boolean().withDefault(const Constant(false))(); // e.g., Knorr/Maggi
  IntColumn get rating => integer().withDefault(const Constant(0))(); // For learning preferences
}

@DataClassName('RecipeIngredientEntry')
class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
}

@DataClassName('MealPlanEntry')
class MealPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()(); // breakfast, lunch, dinner, snack
  IntColumn get recipeId => integer().nullable().references(Recipes, #id)();
  TextColumn get customEntryName => text().nullable()(); // For "Pizza" or "Fertiglasagne"
}

@DriftDatabase(tables: [Brochures, Offers, Recipes, RecipeIngredients, MealPlans])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // if (kDebugMode) {
        //   // Validate database schema in debug mode
        //   await validateDatabaseSchema();
        // }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

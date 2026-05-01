import 'package:drift/drift.dart';
import '../../domain/entities/meal_plan.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../local/database.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  final AppDatabase db;

  MealPlanRepositoryImpl(this.db);

  @override
  Future<List<MealPlan>> getMealPlansForRange(DateTime start, DateTime end) async {
    final query = db.select(db.mealPlans)
      ..where((t) => t.date.isBetweenValues(start, end));
    final rows = await query.get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<int> insertMealPlan(MealPlan mealPlan) async {
    return await db.into(db.mealPlans).insert(
          MealPlansCompanion.insert(
            date: mealPlan.date,
            mealType: mealPlan.mealType,
            recipeId: Value(mealPlan.recipeId),
            customEntryName: Value(mealPlan.customEntryName),
          ),
        );
  }

  @override
  Future<void> updateMealPlan(MealPlan mealPlan) async {
    final query = db.update(db.mealPlans)..where((t) => t.id.equals(mealPlan.id));
    await query.write(MealPlansCompanion(
      date: Value(mealPlan.date),
      mealType: Value(mealPlan.mealType),
      recipeId: Value(mealPlan.recipeId),
      customEntryName: Value(mealPlan.customEntryName),
    ));
  }

  @override
  Future<void> deleteMealPlan(int id) async {
    final query = db.delete(db.mealPlans)..where((t) => t.id.equals(id));
    await query.go();
  }

  MealPlan _mapToEntity(MealPlanEntry row) {
    return MealPlan(
      id: row.id,
      date: row.date,
      mealType: row.mealType,
      recipeId: row.recipeId,
      customEntryName: row.customEntryName,
    );
  }
}

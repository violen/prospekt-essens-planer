import '../entities/meal_plan.dart';

abstract class MealPlanRepository {
  Future<List<MealPlan>> getMealPlansForRange(DateTime start, DateTime end);
  Future<int> insertMealPlan(MealPlan mealPlan);
  Future<void> updateMealPlan(MealPlan mealPlan);
  Future<void> deleteMealPlan(int id);
}

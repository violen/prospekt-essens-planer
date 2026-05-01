class MealPlan {
  final int id;
  final DateTime date;
  final String mealType;
  final int? recipeId;
  final String? customEntryName;

  MealPlan({
    required this.id,
    required this.date,
    required this.mealType,
    this.recipeId,
    this.customEntryName,
  });
}

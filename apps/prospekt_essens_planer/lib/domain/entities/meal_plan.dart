class MealPlan {
  final int? id;
  final DateTime date;
  final String mealType;
  final int? recipeId;
  final String? customEntryName;

  MealPlan({
    this.id,
    required this.date,
    required this.mealType,
    this.recipeId,
    this.customEntryName,
  });

  MealPlan copyWith({int? id}) {
    return MealPlan(
      id: id ?? this.id,
      date: date,
      mealType: mealType,
      recipeId: recipeId,
      customEntryName: customEntryName,
    );
  }
}

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

  MealPlan copyWith({
    int? id,
    DateTime? date,
    String? mealType,
    int? recipeId,
    String? customEntryName,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
      customEntryName: customEntryName ?? this.customEntryName,
    );
  }
}

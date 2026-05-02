class Recipe {
  final int? id;
  final String name;
  final String? instructions;
  final bool isConvenience;
  final int rating;

  Recipe({
    this.id,
    required this.name,
    this.instructions,
    required this.isConvenience,
    required this.rating,
  });

  Recipe copyWith({int? id}) {
    return Recipe(
      id: id ?? this.id,
      name: name,
      instructions: instructions,
      isConvenience: isConvenience,
      rating: rating,
    );
  }
}

class RecipeIngredient {
  final int? id;
  final int? recipeId;
  final String name;
  final double? amount;
  final String? unit;

  RecipeIngredient({
    this.id,
    this.recipeId,
    required this.name,
    this.amount,
    this.unit,
  });

  RecipeIngredient copyWith({int? id, int? recipeId}) {
    return RecipeIngredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name,
      amount: amount,
      unit: unit,
    );
  }
}

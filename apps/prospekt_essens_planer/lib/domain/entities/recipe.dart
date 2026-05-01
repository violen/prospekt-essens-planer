class Recipe {
  final int id;
  final String name;
  final String? instructions;
  final bool isConvenience;
  final int rating;

  Recipe({
    required this.id,
    required this.name,
    this.instructions,
    required this.isConvenience,
    required this.rating,
  });
}

class RecipeIngredient {
  final int id;
  final int recipeId;
  final String name;
  final double? amount;
  final String? unit;

  RecipeIngredient({
    required this.id,
    required this.recipeId,
    required this.name,
    this.amount,
    this.unit,
  });
}

import '../entities/recipe.dart';

class FixProduct {
  final String name;
  final String brand; // Knorr, Maggi
  final List<String> requiredIngredients;

  FixProduct({
    required this.name,
    required this.brand,
    required this.requiredIngredients,
  });

  /// Converts a FixProduct into a Recipe entity for the matching engine.
  Recipe toRecipe() {
    return Recipe(
      name: '$brand Fix: $name',
      isConvenience: true,
      rating: 0,
    );
  }

  List<RecipeIngredient> toIngredients(int recipeId) {
    return requiredIngredients.map((name) => RecipeIngredient(
      name: name,
      recipeId: recipeId,
    )).toList();
  }
}

class FixProductLibrary {
  static final List<FixProduct> products = [
    FixProduct(
      brand: 'Maggi',
      name: 'Lasagne',
      requiredIngredients: ['Hackfleisch', 'Lasagneplatten', 'Sahne', 'Käse'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Spaghetti Bolognese',
      requiredIngredients: ['Hackfleisch', 'Spaghetti'],
    ),
    FixProduct(
      brand: 'Maggi',
      name: 'Bauerntopf',
      requiredIngredients: ['Hackfleisch', 'Paprika', 'Kartoffeln'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Rahm-Champignons',
      requiredIngredients: ['Champignons', 'Sahne'],
    ),
  ];
}

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
    // --- MAGGI ---
    FixProduct(
      brand: 'Maggi',
      name: 'Lasagne',
      requiredIngredients: ['Hackfleisch', 'Lasagneplatten', 'Sahne', 'Käse'],
    ),
    FixProduct(
      brand: 'Maggi',
      name: 'Bauerntopf',
      requiredIngredients: ['Hackfleisch', 'Paprika', 'Kartoffeln'],
    ),
    FixProduct(
      brand: 'Maggi',
      name: 'Spaghetti Bolognese',
      requiredIngredients: ['Hackfleisch', 'Spaghetti'],
    ),
    FixProduct(
      brand: 'Maggi',
      name: 'Chili con Carne',
      requiredIngredients: ['Hackfleisch', 'Kidneybohnen', 'Mais'],
    ),
    FixProduct(
      brand: 'Maggi',
      name: 'Gulasch',
      requiredIngredients: ['Gulasch', 'Zwiebeln'],
    ),

    // --- KNORR ---
    FixProduct(
      brand: 'Knorr',
      name: 'Spaghetti Bolognese',
      requiredIngredients: ['Hackfleisch', 'Spaghetti'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Bolognese Unsere Beste!',
      requiredIngredients: ['Hackfleisch', 'Spaghetti'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Rahm Champignons',
      requiredIngredients: ['Champignons', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Gulasch',
      requiredIngredients: ['Gulasch', 'Zwiebeln'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Lachs-Sahne Gratin',
      requiredIngredients: ['Lachs', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Nudel-Schinken Gratin',
      requiredIngredients: ['Schinken', 'Nudeln', 'Sahne', 'Käse'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Paprika-Rahm Schnitzel',
      requiredIngredients: ['Schnitzel', 'Paprika', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Züricher Geschnetzeltes',
      requiredIngredients: ['Geschnetzeltes', 'Champignons', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Hackbällchen Toscana',
      requiredIngredients: ['Hackfleisch', 'Käse', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Puten Geschnetzeltes',
      requiredIngredients: ['Putenbrust', 'Sahne', 'Champignons'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Bauerntopf mit Hackfleisch',
      requiredIngredients: ['Hackfleisch', 'Paprika', 'Kartoffeln'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Kartoffel Gratin',
      requiredIngredients: ['Kartoffeln', 'Sahne', 'Käse'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Brokkoli Gratin',
      requiredIngredients: ['Brokkoli', 'Käse', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Hackfleisch Jäger Art',
      requiredIngredients: ['Hackfleisch', 'Champignons'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Lachs auf Blattspinat',
      requiredIngredients: ['Lachs', 'Blattspinat', 'Sahne'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Spaghetti alla Carbonara',
      requiredIngredients: ['Speck', 'Sahne', 'Spaghetti'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Lasagne',
      requiredIngredients: ['Hackfleisch', 'Lasagneplatten', 'Käse', 'Milch'],
    ),
    FixProduct(
      brand: 'Knorr',
      name: 'Gefüllte Ofen-Paprika',
      requiredIngredients: ['Paprika', 'Hackfleisch', 'Käse'],
    ),
  ];
}

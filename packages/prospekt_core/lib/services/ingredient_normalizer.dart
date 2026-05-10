import '../entities/fix_product.dart';

class IngredientNormalizer {
  // --- MAPPING DICTIONARY ---
  // Maps marketing terms or variations to a base ingredient name.
  static const Map<String, String> _normalizationMap = {
    'kartoffeln': 'Kartoffel',
    'speisekartoffeln': 'Kartoffel',
    'frühkartoffeln': 'Kartoffel',
    'netz kartoffeln': 'Kartoffel',
    'hackfleisch': 'Hackfleisch',
    'rinderhack': 'Hackfleisch',
    'rinderhackfleisch': 'Hackfleisch',
    'gemischtes hack': 'Hackfleisch',
    'rinderminis': 'Hackfleisch',
    'schweinehack': 'Hackfleisch',
    'schweinehackfleisch': 'Hackfleisch',
    'geflügelhack': 'Hackfleisch',
    'hähnchenbrust': 'Hähnchen',
    'hähnchenfilet': 'Hähnchen',
    'hähnchenbrustfilet': 'Hähnchen',
    'putenbrust': 'Pute',
    'putenfilet': 'Pute',
    'tomaten': 'Tomate',
    'strauchtomaten': 'Tomate',
    'rispentomaten': 'Tomate',
    'kirschtomaten': 'Tomate',
    'cherrytomaten': 'Tomate',
    'gurken': 'Gurke',
    'schlangengurke': 'Gurke',
    'biogurke': 'Gurke',
    'bio-gurke': 'Gurke',
    'landgurke': 'Gurke',
    'schinkenschnitzel': 'Schwein',
    'minutensteaks': 'Schwein',
    'paprika': 'Paprika',
    'blockpaprika': 'Paprika',
    'spitzpaprika': 'Paprika',
    'zwiebeln': 'Zwiebel',
    'speisezwiebeln': 'Zwiebel',
    'rote zwiebeln': 'Zwiebel',
    'knoblauch': 'Knoblauch',
    'ingwer': 'Ingwer',
    'sahne': 'Sahne',
    'schlagsahne': 'Sahne',
    'kochzahne': 'Sahne',
    'schlagrahm': 'Sahne',
    'milch': 'Milch',
    'frischmilch': 'Milch',
    'h-milch': 'Milch',
    'käse': 'Käse',
    'gouda': 'Käse',
    'emmentaler': 'Käse',
    'geriebener käse': 'Käse',
    'pizzakäse': 'Käse',
    'nudeln': 'Nudeln',
    'spaghetti': 'Nudeln',
    'penne': 'Nudeln',
    'fusilli': 'Nudeln',
    'eier': 'Ei',
    'frische eier': 'Ei',
    'freilandeier': 'Ei',
  };

  // --- READY MEAL KEYWORDS ---
  static const List<String> _readyMealKeywords = [
    'pizza', 'lasagne', 'paella', 'rahmspinat', 'fischstäbchen', 'pommes', 'baguette'
  ];

  /// Normalizes a raw product name to its base ingredient or ready-meal name.
  String normalize(String rawName) {
    final lower = rawName.toLowerCase();

    // 1. Check for Ready Meals first (high priority)
    for (final meal in _readyMealKeywords) {
      if (lower.contains(meal)) {
        // Return capitalized meal name (e.g., 'Pizza')
        return meal[0].toUpperCase() + meal.substring(1);
      }
    }

    // 2. Check the mapping dictionary
    // We check if any key is contained in the raw name
    for (final entry in _normalizationMap.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    // 3. Check against FixProductLibrary ingredients as a fallback whitelist
    for (final product in FixProductLibrary.products) {
      for (final ingredient in product.requiredIngredients) {
        if (lower.contains(ingredient.toLowerCase())) {
          return ingredient;
        }
      }
    }

    // 4. Fallback: Just return the original name (cleaned up)
    return rawName;
  }

  /// Returns true if the raw name likely indicates a full meal.
  bool isReadyMeal(String rawName) {
    final lower = rawName.toLowerCase();
    return _readyMealKeywords.any((meal) => lower.contains(meal));
  }
}

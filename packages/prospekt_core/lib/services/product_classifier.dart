import '../entities/fix_product.dart';

enum ProductCategory { food, drink, nonFood, unknown }

class ProductClassifier {
  // --- DRINKS DICTIONARY ---
  static const List<String> _drinksBlacklist = [
    'bier', 'pils', 'weizen', 'radler', 'export', 'helles', 'stout', 'ale',
    'cola', 'fanta', 'sprite', 'limonade', 'limo', 'spezi', 'softdrink',
    'saft', 'nektar', 'schorle', 'direktsaft',
    'wasser', 'sprudel', 'mineralwasser', 'medium', 'still',
    'wein', 'sekt', 'prosecco', 'champagner', 'rose', 'rotwein', 'weißwein',
    'rum', 'gin', 'wodka', 'vodka', 'whisky', 'whiskey', 'likör', 'schnaps',
    'energy', 'red bull', 'monster', 'rockstar',
    'kaffee', 'espresso', 'cappuccino', 'tee', 'eistee'
  ];

  // --- NON-FOOD DICTIONARY ---
  static const List<String> _nonFoodBlacklist = [
    'waschmittel', 'weichspüler', 'reiniger', 'spülmittel', 'badreiniger', 'glasreiniger',
    'shampoo', 'duschgel', 'seife', 'zahncreme', 'zahnbürste', 'deo', 'rasierer', 'hygiene',
    'toilettenpapier', 'klopapier', 'küchenrolle', 'taschentücher', 'windeln',
    'hundefutter', 'katzenfutter', 'tiernahrung', 'vogelfutter',
    'pfanne', 'topf', 'messer', 'gabel', 'löffel', 'geschirr', 'grill', 'kohle',
    'blumenerde', 'dünger', 'pflanze', 'blumen',
    'socken', 'unterwäsche', 'shirt', 'hose', 'schuhe',
    'batterie', 'lampe', 'leuchte', 'kerze'
  ];

  // --- UNIT HEURISTICS ---
  static const List<String> _drinkUnits = ['kasten', 'kiste', 'flasche', 'fl.', 'vol.-%', 'vol%'];
  static const List<String> _nonFoodUnits = ['wl', 'waschladungen', 'blatt', 'paar', 'cm', 'm', 'zoll', 'watt'];

  /// Classifies a product based on its name and optional unit.
  ProductCategory classify(String name, [String? unit]) {
    final lowerName = name.toLowerCase();
    final lowerUnit = unit?.toLowerCase();

    // 1. Check against the FixProduct whitelist (Ultimate Food Source)
    if (_isInFoodWhitelist(lowerName)) {
      return ProductCategory.food;
    }

    // 2. Check for Drink heuristics
    if (_isDrink(lowerName, lowerUnit)) {
      return ProductCategory.drink;
    }

    // 3. Check for Non-Food heuristics
    if (_isNonFood(lowerName, lowerUnit)) {
      return ProductCategory.nonFood;
    }

    // 4. Default to unknown (safer than discarding potentially valid food)
    return ProductCategory.unknown;
  }

  bool _isInFoodWhitelist(String name) {
    // Check if the name matches any ingredient in our FixProductLibrary
    for (final product in FixProductLibrary.products) {
      for (final ingredient in product.requiredIngredients) {
        if (name.contains(ingredient.toLowerCase())) {
          return true;
        }
      }
    }
    
    // Common food keywords that are almost always valid
    const foodKeywords = ['fleisch', 'wurst', 'käse', 'apfel', 'tomate', 'brot', 'milch', 'kartoffel', 'nudel', 'gemüse', 'obst', 'gurke', 'erdbeere', 'steak', 'joghurt', 'ei'];
    if (foodKeywords.any((k) => name.contains(k))) {
      return true;
    }

    return false;
  }

  bool _isDrink(String name, String? unit) {
    // Check name against drinks blacklist
    if (_drinksBlacklist.any((d) => name.contains(d))) {
      return true;
    }

    // Check unit
    if (unit != null && _drinkUnits.any((u) => unit.contains(u))) {
      // Special case: "Flasche" could be oil/vinegar, so we combine with name check
      if (unit.contains('kasten') || unit.contains('kiste')) return true;
    }

    return false;
  }

  bool _isNonFood(String name, String? unit) {
    // Check name against non-food blacklist
    if (_nonFoodBlacklist.any((nf) => name.contains(nf))) {
      return true;
    }

    // Check unit (e.g., Waschladungen)
    if (unit != null) {
      if (unit.contains('wl') || unit.contains('waschladungen') || unit.contains('blatt')) {
        return true;
      }
    }

    return false;
  }
}

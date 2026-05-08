import 'package:string_similarity/string_similarity.dart';
import '../entities/offer.dart';
import '../entities/recipe.dart';

class MatchResult {
  final RecipeIngredient ingredient;
  final Offer? matchedOffer;
  final double confidence;
  final double estimatedStandardPrice;

  MatchResult({
    required this.ingredient,
    this.matchedOffer,
    required this.confidence,
    this.estimatedStandardPrice = 0.0,
  });

  bool get isMatch => matchedOffer != null && confidence > 0.6;

  double get currentPrice => matchedOffer?.price ?? estimatedStandardPrice;
  double get savings => isMatch ? (estimatedStandardPrice - currentPrice) : 0.0;
}

class RecipeMatchSummary {
  final Recipe recipe;
  final List<MatchResult> ingredientMatches;
  final double totalCurrentPrice;
  final double totalEstimatedStandardPrice;
  final bool canUseConvenience;

  RecipeMatchSummary({
    required this.recipe,
    required this.ingredientMatches,
    required this.totalCurrentPrice,
    required this.totalEstimatedStandardPrice,
    this.canUseConvenience = false,
  });

  double get totalSavings => totalEstimatedStandardPrice - totalCurrentPrice;
  double get matchRate => ingredientMatches.isEmpty 
      ? 0 
      : ingredientMatches.where((m) => m.isMatch).length / ingredientMatches.length;
}

class MatchingService {
  /// Matches a list of ingredients against available offers and calculates savings.
  RecipeMatchSummary matchRecipe(
    Recipe recipe,
    List<RecipeIngredient> ingredients,
    List<Offer> availableOffers,
  ) {
    final results = ingredients.map((ingredient) {
      return _findBestMatch(ingredient, availableOffers);
    }).toList();

    double currentTotal = 0;
    double standardTotal = 0;

    for (final res in results) {
      currentTotal += res.currentPrice;
      standardTotal += res.estimatedStandardPrice;
    }

    // Heuristic for convenience matching
    final bool canUseConvenience = recipe.isConvenience;

    return RecipeMatchSummary(
      recipe: recipe,
      ingredientMatches: results,
      totalCurrentPrice: currentTotal,
      totalEstimatedStandardPrice: standardTotal,
      canUseConvenience: canUseConvenience,
    );
  }

  MatchResult _findBestMatch(RecipeIngredient ingredient, List<Offer> offers) {
    // Standard price heuristic: In a real app, this would come from a database.
    final double standardPrice = (ingredient.amount ?? 1.0) * 2.50;

    if (offers.isEmpty) {
      return MatchResult(
        ingredient: ingredient, 
        confidence: 0, 
        estimatedStandardPrice: standardPrice,
      );
    }

    final ingredientName = ingredient.name.toLowerCase();
    Offer? bestOffer;
    double highestScore = 0;

    for (final offer in offers) {
      final offerName = offer.productName.toLowerCase();
      final normalizedOfferName = offer.normalizedName?.toLowerCase();
      
      // 1. Direct contains check (High weight)
      // Check both normalized and raw name
      if (normalizedOfferName != null && (normalizedOfferName.contains(ingredientName) || ingredientName.contains(normalizedOfferName))) {
        double score = 0.9; // Higher confidence for normalized matches
        if (score > highestScore) {
          highestScore = score;
          bestOffer = offer;
        }
      } else if (offerName.contains(ingredientName) || ingredientName.contains(offerName)) {
        double score = 0.8;
        if ((offerName.length - ingredientName.length).abs() < 5) {
          score += 0.15;
        }
        
        if (score > highestScore) {
          highestScore = score;
          bestOffer = offer;
        }
      }

      // 2. Fuzzy similarity
      final double fuzzyScore = ingredientName.similarityTo(normalizedOfferName ?? offerName);
      if (fuzzyScore > highestScore) {
        highestScore = fuzzyScore;
        bestOffer = offer;
      }
    }

    return MatchResult(
      ingredient: ingredient,
      matchedOffer: bestOffer,
      confidence: highestScore,
      estimatedStandardPrice: standardPrice,
    );
  }
}

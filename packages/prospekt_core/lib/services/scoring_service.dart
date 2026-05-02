import 'matching_service.dart';

class ScoringService {
  /// Ranks a list of recipes based on match results and user preferences.
  List<RecipeMatchSummary> rankRecipes(List<RecipeMatchSummary> summaries) {
    final ranked = List<RecipeMatchSummary>.from(summaries);
    
    ranked.sort((a, b) {
      final scoreA = _calculateScore(a);
      final scoreB = _calculateScore(b);
      return scoreB.compareTo(scoreA); // Higher score first
    });

    return ranked;
  }

  double _calculateScore(RecipeMatchSummary summary) {
    // 1. Match Rate (Weight: 60%)
    // How much of the recipe is on offer?
    final double matchScore = summary.matchRate * 60;

    // 2. User Rating (Weight: 30%)
    // Convert 0-5 rating to 0-30 points
    final double ratingScore = (summary.recipe.rating / 5) * 30;

    // 3. Savings Bonus (Weight: 10%)
    // Bonus if total savings are significant (> 2.00 €)
    double savingsScore = 0;
    if (summary.totalSavings > 2.0) {
      savingsScore = 10;
    } else if (summary.totalSavings > 0) {
      savingsScore = (summary.totalSavings / 2.0) * 10;
    }

    return matchScore + ratingScore + savingsScore;
  }
}

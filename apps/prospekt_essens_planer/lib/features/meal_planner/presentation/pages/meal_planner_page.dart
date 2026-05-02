import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../controllers/meal_planner_controller.dart';
import '../controllers/meal_planner_state.dart';

class MealPlannerPage extends ConsumerWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(mealPlannerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(mealPlannerControllerProvider.notifier).loadRecommendations(),
            tooltip: l10n.refreshRecommendations,
          ),
        ],
      ),
      body: _buildBody(context, ref, state, l10n),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, MealPlannerState state, AppLocalizations l10n) {
    if (state.status == MealPlannerStatus.loading) {
      return Center(
        child: Semantics(
          label: l10n.searchingRecommendations,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == MealPlannerStatus.error) {
      return Center(child: Text(l10n.errorPrefix(state.errorMessage ?? '')));
    }

    if (state.recommendations.isEmpty) {
      return EmptyState(
        icon: Icons.restaurant_menu,
        title: l10n.noRecommendationsTitle,
        message: l10n.noRecommendationsMessage,
      );
    }

    return ListView.builder(
      itemCount: state.recommendations.length,
      itemBuilder: (context, index) {
        final summary = state.recommendations[index];
        final matchPercentage = (summary.matchRate * 100).toStringAsFixed(0);
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(summary.recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Semantics(
              label: '${l10n.matchPercentage(matchPercentage)}. ${l10n.savingsAmount(summary.totalSavings.toStringAsFixed(2))}',
              child: Text(
                'Match: $matchPercentage% | Ersparnis: ${summary.totalSavings.toStringAsFixed(2)} €',
                style: TextStyle(color: summary.matchRate > 0.5 ? Colors.green : Colors.grey),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Zutaten & Angebote:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...summary.ingredientMatches.map((match) => ListTile(
                      dense: true,
                      title: Text(match.ingredient.name),
                      subtitle: match.isMatch 
                        ? Text('Angebot: ${match.matchedOffer!.productName} (${match.matchedOffer!.price.toStringAsFixed(2)} €)')
                        : Text(l10n.noOfferFound, style: const TextStyle(fontStyle: FontStyle.italic)),
                      trailing: Semantics(
                        label: match.isMatch ? l10n.onOffer : l10n.noOfferFound,
                        child: Icon(
                          match.isMatch ? Icons.check_circle : Icons.help_outline, 
                          color: match.isMatch ? Colors.green : Colors.orange,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

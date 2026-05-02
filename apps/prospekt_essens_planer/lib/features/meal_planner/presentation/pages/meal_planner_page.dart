import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../controllers/meal_planner_controller.dart';
import '../controllers/meal_planner_state.dart';

class MealPlannerPage extends ConsumerWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealPlannerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Essensplaner Empfehlungen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(mealPlannerControllerProvider.notifier).loadRecommendations(),
            tooltip: 'Empfehlungen aktualisieren',
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, MealPlannerState state) {
    if (state.status == MealPlannerStatus.loading) {
      return Center(
        child: Semantics(
          label: 'Suche nach passenden Rezepten...',
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == MealPlannerStatus.error) {
      return Center(child: Text('Fehler: ${state.errorMessage}'));
    }

    if (state.recommendations.isEmpty) {
      return const EmptyState(
        icon: Icons.restaurant_menu,
        title: 'Noch keine Empfehlungen',
        message: 'Importiere ein Prospekt oder erstelle Rezepte, um personalisierte Essensvorschläge zu erhalten.',
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
              label: 'Übereinstimmung: $matchPercentage Prozent. Ersparnis: ${summary.totalSavings.toStringAsFixed(2)} Euro',
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
                        : const Text('Kein Angebot gefunden', style: TextStyle(fontStyle: FontStyle.italic)),
                      trailing: Semantics(
                        label: match.isMatch ? 'Im Angebot' : 'Kein Angebot',
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

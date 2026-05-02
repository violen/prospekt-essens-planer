import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, MealPlannerState state) {
    if (state.status == MealPlannerStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == MealPlannerStatus.error) {
      return Center(child: Text('Fehler: ${state.errorMessage}'));
    }

    if (state.recommendations.isEmpty) {
      return const Center(child: Text('Keine Rezepte gefunden. Importiere ein Prospekt oder erstelle Rezepte.'));
    }

    return ListView.builder(
      itemCount: state.recommendations.length,
      itemBuilder: (context, index) {
        final summary = state.recommendations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(summary.recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Match: ${(summary.matchRate * 100).toStringAsFixed(0)}% | Ersparnis: ${summary.totalSavings.toStringAsFixed(2)} €',
              style: TextStyle(color: summary.matchRate > 0.5 ? Colors.green : Colors.grey),
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
                      trailing: match.isMatch 
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.help_outline, color: Colors.orange),
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

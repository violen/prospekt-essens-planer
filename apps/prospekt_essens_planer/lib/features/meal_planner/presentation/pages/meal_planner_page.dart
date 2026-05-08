import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../controllers/meal_planner_controller.dart';
import '../controllers/meal_planner_state.dart';
import '../controllers/weekly_planner_controller.dart';

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
        final isReadyMeal = summary.recipe.id == -2;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            leading: Icon(isReadyMeal ? Icons.fastfood_outlined : Icons.restaurant),
            title: Row(
              children: [
                Expanded(child: Text(summary.recipe.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (isReadyMeal)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Fertiggericht', style: TextStyle(fontSize: 10, color: Colors.orange)),
                  ),
              ],
            ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Zutaten & Angebote:', style: TextStyle(fontWeight: FontWeight.bold)),
                        FilledButton.icon(
                          onPressed: () => _showPlanAssignmentDialog(context, ref, summary.recipe, l10n),
                          icon: const Icon(Icons.calendar_month),
                          label: Text(l10n.schedule),
                        ),
                      ],
                    ),
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

  void _showPlanAssignmentDialog(BuildContext context, WidgetRef ref, Recipe recipe, AppLocalizations l10n) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.scheduleMeal(recipe.name)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = startOfWeek.add(Duration(days: index));
              final dateStr = DateFormat('EEEE, dd.MM.', 'de').format(date);
              
              return ListTile(
                title: Text(dateStr),
                subtitle: Text(l10n.mealTimeSelection),
                onTap: () {
                  _showMealTypePicker(context, ref, date, recipe, l10n);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMealTypePicker(BuildContext context, WidgetRef ref, DateTime date, Recipe recipe, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: Text(l10n.lunch),
            onTap: () {
              ref.read(weeklyPlannerControllerProvider.notifier).assignRecipe(date, 'lunch', recipe);
              Navigator.pop(context); // Close sheet
              Navigator.pop(context); // Close dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_outlined),
            title: Text(l10n.dinner),
            onTap: () {
              ref.read(weeklyPlannerControllerProvider.notifier).assignRecipe(date, 'dinner', recipe);
              Navigator.pop(context); // Close sheet
              Navigator.pop(context); // Close dialog
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

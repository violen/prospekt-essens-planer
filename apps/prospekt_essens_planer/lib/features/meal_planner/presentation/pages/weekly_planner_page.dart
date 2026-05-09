import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/controllers/tutorial_controller.dart';
import '../../../../core/presentation/widgets/skeleton_card.dart';
import '../controllers/weekly_planner_controller.dart';

class WeeklyPlannerPage extends ConsumerWidget {
  const WeeklyPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(weeklyPlannerControllerProvider);
    final controller = ref.read(weeklyPlannerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weeklyPlanner),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ref.read(tutorialControllerProvider.notifier).restartTutorial(),
            tooltip: l10n.startTutorial,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => controller.previousWeek(),
          ),
          Center(
            child: Text(
              l10n.kwPrefix(DateFormat('w', 'de').format(state.selectedWeekStart)),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => controller.nextWeek(),
          ),
        ],
      ),
      body: state.isLoading 
          ? const SkeletonList()
          : ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = state.selectedWeekStart.add(Duration(days: index));
                return _DaySection(date: date, l10n: l10n);
              },
            ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final DateTime date;
  final AppLocalizations l10n;

  const _DaySection({required this.date, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            DateFormat('EEEE, dd.MM.', 'de').format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _MealSlot(date: date, mealType: 'lunch', label: l10n.lunch, l10n: l10n),
        _MealSlot(date: date, mealType: 'dinner', label: l10n.dinner, l10n: l10n),
        const Divider(),
      ],
    );
  }
}

class _MealSlot extends ConsumerWidget {
  final DateTime date;
  final String mealType;
  final String label;
  final AppLocalizations l10n;

  const _MealSlot({
    required this.date,
    required this.mealType,
    required this.label,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weeklyPlannerControllerProvider);
    final plan = state.getPlan(date, mealType);

    return ListTile(
      leading: const Icon(Icons.restaurant_outlined),
      title: Text(label),
      subtitle: plan != null 
          ? _MealPlanTitle(recipeId: plan.recipeId, customName: plan.customEntryName, l10n: l10n)
          : Text(l10n.nothingPlanned, style: const TextStyle(fontStyle: FontStyle.italic)),
      trailing: plan != null 
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(weeklyPlannerControllerProvider.notifier).removePlan(plan.id!),
            )
          : const Icon(Icons.add),
      onTap: () => _showRecipePicker(context, ref, date, mealType, l10n),
    );
  }

  void _showRecipePicker(BuildContext context, WidgetRef ref, DateTime date, String mealType, AppLocalizations l10n) async {
    final recipes = await ref.read(recipeRepositoryProvider).getAllRecipes();
    
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListTile(
              title: Text(recipe.name),
              onTap: () {
                ref.read(weeklyPlannerControllerProvider.notifier).assignRecipe(date, mealType, recipe);
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    }
  }
}

class _MealPlanTitle extends ConsumerWidget {
  final int? recipeId;
  final String? customName;
  final AppLocalizations l10n;

  const _MealPlanTitle({this.recipeId, this.customName, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customName != null) return Text(customName!);
    if (recipeId == null) return Text(l10n.unknown);

    return FutureBuilder<Recipe>(
      future: ref.read(recipeRepositoryProvider).getRecipeById(recipeId!),
      builder: (context, snapshot) {
        if (snapshot.hasData) return Text(snapshot.data!.name, style: const TextStyle(fontWeight: FontWeight.bold));
        return Text(l10n.loadingRecipe);
      },
    );
  }
}

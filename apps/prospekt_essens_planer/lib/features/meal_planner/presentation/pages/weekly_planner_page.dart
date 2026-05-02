import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';
import '../controllers/weekly_planner_controller.dart';

class WeeklyPlannerPage extends ConsumerWidget {
  const WeeklyPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weeklyPlannerControllerProvider);
    final controller = ref.read(weeklyPlannerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenplaner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => controller.previousWeek(),
          ),
          Center(
            child: Text(
              'KW ${DateFormat('w').format(state.selectedWeekStart)}',
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = state.selectedWeekStart.add(Duration(days: index));
                return _DaySection(date: date);
              },
            ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final DateTime date;

  const _DaySection({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            DateFormat('EEEE, dd.MM.').format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _MealSlot(date: date, mealType: 'lunch', label: 'Mittagessen'),
        _MealSlot(date: date, mealType: 'dinner', label: 'Abendessen'),
        const Divider(),
      ],
    );
  }
}

class _MealSlot extends ConsumerWidget {
  final DateTime date;
  final String mealType;
  final String label;

  const _MealSlot({
    required this.date,
    required this.mealType,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weeklyPlannerControllerProvider);
    final plan = state.getPlan(date, mealType);

    return ListTile(
      leading: const Icon(Icons.restaurant_outlined),
      title: Text(label),
      subtitle: plan != null 
          ? _MealPlanTitle(recipeId: plan.recipeId, customName: plan.customEntryName)
          : const Text('Noch nichts geplant', style: TextStyle(fontStyle: FontStyle.italic)),
      trailing: plan != null 
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(weeklyPlannerControllerProvider.notifier).removePlan(plan.id!),
            )
          : const Icon(Icons.add),
      onTap: () => _showRecipePicker(context, ref, date, mealType),
    );
  }

  void _showRecipePicker(BuildContext context, WidgetRef ref, DateTime date, String mealType) async {
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

  const _MealPlanTitle({this.recipeId, this.customName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customName != null) return Text(customName!);
    if (recipeId == null) return const Text('Unbekannt');

    return FutureBuilder<Recipe>(
      future: ref.read(recipeRepositoryProvider).getRecipeById(recipeId!),
      builder: (context, snapshot) {
        if (snapshot.hasData) return Text(snapshot.data!.name, style: const TextStyle(fontWeight: FontWeight.bold));
        return const Text('Lade Rezept...');
      },
    );
  }
}

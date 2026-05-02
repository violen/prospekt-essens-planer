import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../../../../core/providers.dart';
import '../../../../core/presentation/widgets/empty_state.dart';

class RecipeManagementPage extends ConsumerWidget {
  const RecipeManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We don't have a specific controller for this yet, so we fetch directly
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezepte Verwalten'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: ref.watch(recipeRepositoryProvider).getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long,
              title: 'Keine Rezepte',
              message: 'Füge deine ersten Rezepte hinzu, um den Planer zu nutzen.',
              onAction: () => _showAddRecipeDialog(context, ref),
              actionLabel: 'Rezept erstellen',
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                title: Text(recipe.name),
                subtitle: Text(recipe.isConvenience ? 'Convenience / Tüte' : 'Frisch kochen'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(recipeRepositoryProvider).deleteRecipe(recipe.id!);
                    // Trigger rebuild - ideally use a StateNotifier here
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipeDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    bool isConvenience = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Neues Rezept'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name des Gerichts'),
                autofocus: true,
              ),
              SwitchListTile(
                title: const Text('Convenience (Knorr/Maggi)'),
                value: isConvenience,
                onChanged: (val) => setState(() => isConvenience = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await ref.read(recipeRepositoryProvider).insertRecipe(
                    Recipe(
                      name: nameController.text,
                      isConvenience: isConvenience,
                      rating: 0,
                    ),
                    [], // No ingredients for now in this simple dialog
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}

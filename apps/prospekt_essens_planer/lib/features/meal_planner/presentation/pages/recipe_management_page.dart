import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../controllers/recipe_controller.dart';

class RecipeManagementPage extends ConsumerWidget {
  const RecipeManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(recipeControllerProvider);
    final controller = ref.read(recipeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageRecipes),
      ),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : state.recipes.isEmpty
              ? EmptyState(
                  icon: Icons.receipt_long,
                  title: l10n.noRecipesTitle,
                  message: l10n.noRecipesMessage,
                  onAction: () => _showAddRecipeDialog(context, l10n, controller),
                  actionLabel: l10n.createRecipe,
                )
              : ListView.builder(
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = state.recipes[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                      title: Text(recipe.name),
                      subtitle: Text(recipe.isConvenience ? l10n.convenienceProduct : l10n.freshCooking),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => controller.deleteRecipe(recipe.id!),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_recipe_fab'),
        onPressed: () => _showAddRecipeDialog(context, l10n, controller),
        tooltip: l10n.createRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context, AppLocalizations l10n, RecipeController controller) {
    final nameController = TextEditingController();
    bool isConvenience = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.newRecipe),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.dishName),
                autofocus: true,
              ),
              SwitchListTile(
                title: Text(l10n.convenienceProduct),
                value: isConvenience,
                onChanged: (val) => setState(() => isConvenience = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await controller.addRecipe(nameController.text, isConvenience);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(l10n.create),
            ),
          ],
        ),
      ),
    );
  }
}

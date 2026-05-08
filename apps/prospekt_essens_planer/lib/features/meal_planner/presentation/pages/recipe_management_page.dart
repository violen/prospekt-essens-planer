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
      body: state.errorMessage != null
          ? Center(child: Text(l10n.errorPrefix(state.errorMessage!), style: const TextStyle(color: Colors.red)))
          : state.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : state.recipes.isEmpty
                  ? EmptyState(
                  icon: Icons.receipt_long,
                  title: l10n.noRecipesTitle,
                  message: l10n.noRecipesMessage,
                  onAction: () => _showAddRecipeSheet(context, l10n, controller, state.availableIngredients),
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
        onPressed: () => _showAddRecipeSheet(context, l10n, controller, state.availableIngredients),
        tooltip: l10n.createRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeSheet(
    BuildContext context, 
    AppLocalizations l10n, 
    RecipeController controller,
    List<String> suggestions,
  ) {
    final nameController = TextEditingController();
    final ingredientController = TextEditingController();
    final FocusNode ingredientFocusNode = FocusNode();
    bool isConvenience = false;
    final List<String> addedIngredients = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.newRecipe, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.dishName,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(l10n.convenienceProduct),
                value: isConvenience,
                onChanged: (val) => setSheetState(() => isConvenience = val),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text('Zutaten hinzufügen', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.length < 2) {
                    return const Iterable<String>.empty();
                  }
                  return suggestions.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  setSheetState(() {
                    if (!addedIngredients.contains(selection)) {
                      addedIngredients.add(selection);
                    }
                    ingredientController.clear();
                  });
                  ingredientFocusNode.requestFocus();
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Zutat suchen (z.B. Kartoffel)...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setSheetState(() {
                          if (!addedIngredients.contains(value)) {
                            addedIngredients.add(value);
                          }
                          controller.clear();
                        });
                        focusNode.requestFocus();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: addedIngredients.map((ing) => Chip(
                  label: Text(ing),
                  onDeleted: () => setSheetState(() => addedIngredients.remove(ing)),
                )).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        await controller.addRecipe(
                          nameController.text, 
                          isConvenience, 
                          addedIngredients,
                        );
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: Text(l10n.create),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

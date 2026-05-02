import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/ingestion_controller.dart';
import '../controllers/ingestion_state.dart';

class BrochureIngestionPage extends ConsumerWidget {
  const BrochureIngestionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ingestionControllerProvider);
    final controller = ref.read(ingestionControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importBrochure),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.status == IngestionStatus.loading || 
                               state.status == IngestionStatus.parsing 
                        ? null 
                        : () => controller.pickAndParseFile(),
                    icon: const Icon(Icons.file_upload),
                    label: Text(l10n.selectFile),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: state.status == IngestionStatus.loading || 
                             state.status == IngestionStatus.parsing 
                      ? null 
                      : () => controller.takePhotoAndParse(),
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.status == IngestionStatus.loading || 
                state.status == IngestionStatus.parsing)
              const Center(child: CircularProgressIndicator())
            else if (state.status == IngestionStatus.error)
              Text(l10n.errorPrefix(state.errorMessage ?? ''), 
                   style: const TextStyle(color: Colors.red))
            else if (state.extractedOffers.isNotEmpty) ...[
              Text(l10n.offersFound(state.extractedOffers.length), 
                   style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: state.extractedOffers.length,
                  itemBuilder: (context, index) {
                    final offer = state.extractedOffers[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => controller.removeOffer(index),
                      child: Card(
                        child: ListTile(
                          title: Text(offer.productName),
                          subtitle: Text(offer.unit ?? ''),
                          trailing: Text('${offer.price.toStringAsFixed(2)} €'),
                          onTap: () => _showEditOfferDialog(context, ref, index, offer),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showSaveDialog(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(l10n.saveOffers),
              ),
            ] else
              Center(child: Text(l10n.noFileSelected)),
          ],
        ),
      ),
    );
  }

  void _showEditOfferDialog(BuildContext context, WidgetRef ref, int index, Offer offer) {
    final nameController = TextEditingController(text: offer.productName);
    final priceController = TextEditingController(text: offer.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Angebot bearbeiten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Produktname'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Preis'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text.replaceAll(',', '.')) ?? offer.price;
              ref.read(ingestionControllerProvider.notifier)
                 .updateOffer(index, nameController.text, newPrice);
              Navigator.pop(context);
            },
            child: const Text('Übernehmen'),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.saveBrochure),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.brochureName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(ingestionControllerProvider.notifier)
                 .saveOffers(nameController.text);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

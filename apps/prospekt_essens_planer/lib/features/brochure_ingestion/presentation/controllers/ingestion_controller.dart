import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/providers.dart';
import 'ingestion_state.dart';

final ingestionControllerProvider = StateNotifierProvider<IngestionController, IngestionState>((ref) {
  return IngestionController(ref);
});

class IngestionController extends StateNotifier<IngestionState> {
  final Ref _ref;

  IngestionController(this._ref) : super(IngestionState(status: IngestionStatus.idle));

  Future<void> pickAndParseFile() async {
    state = state.copyWith(status: IngestionStatus.loading);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        state = state.copyWith(status: IngestionStatus.parsing, selectedFile: file);

        // We use a dummy brochure ID for now (0), 
        // as we haven't saved the brochure entry to the DB yet.
        final parser = _ref.read(brochureParserProvider);
        final offers = await parser.parse(file, 0);

        state = state.copyWith(
          status: IngestionStatus.success,
          extractedOffers: offers,
        );
      } else {
        state = state.copyWith(status: IngestionStatus.idle);
      }
    } catch (e) {
      state = state.copyWith(status: IngestionStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> saveOffers(String brochureName) async {
    if (state.selectedFile == null) return;
    
    state = state.copyWith(status: IngestionStatus.loading);
    
    try {
      final brochureRepo = _ref.read(brochureRepositoryProvider);
      final offerRepo = _ref.read(offerRepositoryProvider);

      // 1. Create brochure entry
      final brochureId = await brochureRepo.insertBrochure(
        brochureName, 
        state.selectedFile!.path,
      );

      // 2. Save all offers associated with this brochure
      for (final offer in state.extractedOffers) {
        await offerRepo.insertOffer(offer.copyWith(brochureId: brochureId));
      }

      state = state.copyWith(status: IngestionStatus.success, extractedOffers: []);
    } catch (e) {
      state = state.copyWith(status: IngestionStatus.error, errorMessage: e.toString());
    }
  }

  void updateOffer(int index, String newName, double newPrice) {
    final updatedOffers = List<Offer>.from(state.extractedOffers);
    updatedOffers[index] = updatedOffers[index].copyWith(
      productName: newName,
      price: newPrice,
    );
    state = state.copyWith(extractedOffers: updatedOffers);
  }
}

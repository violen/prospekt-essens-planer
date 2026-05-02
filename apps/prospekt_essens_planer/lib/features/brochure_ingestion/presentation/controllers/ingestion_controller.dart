import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers.dart';
import '../../../../domain/entities/offer.dart';
import 'ingestion_state.dart';

final ingestionControllerProvider = StateNotifierProvider<IngestionController, IngestionState>((ref) {
  return IngestionController(ref);
});

class IngestionController extends StateNotifier<IngestionState> {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  IngestionController(this._ref) : super(IngestionState(status: IngestionStatus.idle));

  Future<void> pickAndParseFile() async {
    state = state.copyWith(status: IngestionStatus.loading);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        await _processFile(File(result.files.single.path!));
      } else {
        state = state.copyWith(status: IngestionStatus.idle);
      }
    } catch (e) {
      state = state.copyWith(status: IngestionStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> takePhotoAndParse() async {
    state = state.copyWith(status: IngestionStatus.loading);

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        await _processFile(File(photo.path));
      } else {
        state = state.copyWith(status: IngestionStatus.idle);
      }
    } catch (e) {
      state = state.copyWith(status: IngestionStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> _processFile(File file) async {
    state = state.copyWith(status: IngestionStatus.parsing, selectedFile: file);

    final parser = _ref.read(brochureParserProvider);
    final offers = await parser.parse(file, 0);

    state = state.copyWith(
      status: IngestionStatus.success,
      extractedOffers: offers,
    );
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

  void removeOffer(int index) {
    final updatedOffers = List<Offer>.from(state.extractedOffers);
    updatedOffers.removeAt(index);
    state = state.copyWith(extractedOffers: updatedOffers);
  }
}

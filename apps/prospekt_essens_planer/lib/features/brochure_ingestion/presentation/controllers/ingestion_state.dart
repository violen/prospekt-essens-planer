import 'dart:io';
import '../../../../domain/entities/offer.dart';

enum IngestionStatus { idle, loading, parsing, success, error }

class IngestionState {
  final IngestionStatus status;
  final File? selectedFile;
  final List<Offer> extractedOffers;
  final String? errorMessage;

  IngestionState({
    required this.status,
    this.selectedFile,
    this.extractedOffers = const [],
    this.errorMessage,
  });

  IngestionState copyWith({
    IngestionStatus? status,
    File? selectedFile,
    List<Offer>? extractedOffers,
    String? errorMessage,
  }) {
    return IngestionState(
      status: status ?? this.status,
      selectedFile: selectedFile ?? this.selectedFile,
      extractedOffers: extractedOffers ?? this.extractedOffers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

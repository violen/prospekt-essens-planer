import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/brochure_parser.dart';

class OcrBrochureParser implements BrochureParser {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<List<Offer>> parse(File file, int brochureId) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      return _extractOffersFromRecognizedText(recognizedText, brochureId);
    } catch (e) {
      return [];
    }
  }

  List<Offer> _extractOffersFromRecognizedText(RecognizedText recognizedText, int brochureId) {
    final List<Offer> offers = [];
    final RegExp priceRegex = RegExp(
      r'(\d{0,3}[\.,](\d{2}|-))\s*€?',
      caseSensitive: false,
    );

    int idCounter = 1;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final text = line.text.trim();
        final matches = priceRegex.allMatches(text);

        for (final match in matches) {
          final priceString = match.group(1)!.replaceAll(',', '.').replaceAll('-', '00');
          final double price = double.tryParse(priceString) ?? 0.0;

          if (price > 0) {
            // In OCR, the product name might be in the same line or nearby.
            // For now, we take the prefix of the line.
            String productName = text.substring(0, match.start).trim();
            
            if (productName.isEmpty || productName.length < 3) {
              // If current line has no name, check the block's previous lines or context.
              // Simple heuristic: just label it for now.
              productName = "OCR Produkt (Raw)";
            }

            offers.add(Offer(
              id: idCounter++,
              brochureId: brochureId,
              productName: productName,
              price: price,
            ));
          }
        }
      }
    }

    return offers;
  }

  void dispose() {
    _textRecognizer.close();
  }
}

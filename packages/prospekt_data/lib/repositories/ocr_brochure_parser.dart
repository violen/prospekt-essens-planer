import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:prospekt_core/prospekt_core.dart';

class OcrBrochureParser implements BrochureParser {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final ProductClassifier _classifier = ProductClassifier();

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
    
    // Improved regex for German prices:
    // Matches: 1,99 | 1.99 | 1,- | 1.00 € | 0,45€ | ,99
    final RegExp priceRegex = RegExp(
      r'(\d{0,3}[\.,](\d{2}|-))\s*€?',
      caseSensitive: false,
    );

    // Regex for common units: kg, g, l, ml, St., Stück, Dose, Pck., Packung
    // Uses word boundaries \b to avoid matching within words (e.g., 'g' in 'Gurken').
    // Reordered to match longer terms first (e.g., 'Stück' before 'St.').
    final RegExp unitRegex = RegExp(
      r'(\b\d*\s*(?:kg|g|l|ml|Stück|St\.?|Dose|Packung|Pck\.?)\b)',
      caseSensitive: false,
    );

    int idCounter = 1;

    for (TextBlock block in recognizedText.blocks) {
      final List<TextLine> lines = block.lines;
      for (int i = 0; i < lines.length; i++) {
        final text = lines[i].text.trim();
        final matches = priceRegex.allMatches(text);

        for (final match in matches) {
          final priceString = match.group(1)!.replaceAll(',', '.').replaceAll('-', '00');
          final double price = double.tryParse(priceString) ?? 0.0;

          if (price > 0) {
            String productName = text.substring(0, match.start).trim();
            String? unit;

            // Check for unit in the current line
            final unitMatch = unitRegex.firstMatch(text);
            if (unitMatch != null) {
              unit = unitMatch.group(1)?.trim();
              productName = productName.replaceFirst(unitMatch.group(1)!, '').trim();
            }

            if ((productName.isEmpty || productName.length < 3) && i > 0) {
              // Try previous line in the block for product name
              productName = lines[i - 1].text.trim();
              
              if (unit == null) {
                final prevUnitMatch = unitRegex.firstMatch(productName);
                if (prevUnitMatch != null) {
                  unit = prevUnitMatch.group(1)?.trim();
                  productName = productName.replaceFirst(prevUnitMatch.group(1)!, '').trim();
                }
              }
            }

            if (productName.isEmpty || productName.length < 3) {
              productName = "Unbekanntes OCR Produkt";
            }

            // Clean up product name from dangling chars
            productName = productName.replaceAll(RegExp(r'^[^\w\däöüÄÖÜß]+|[^\w\däöüÄÖÜß]+$'), '').trim();

            final category = _classifier.classify(productName, unit);
            if (category == ProductCategory.food || category == ProductCategory.unknown) {
              offers.add(Offer(
                id: idCounter++,
                brochureId: brochureId,
                productName: productName,
                price: price,
                unit: unit,
              ));
            }
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

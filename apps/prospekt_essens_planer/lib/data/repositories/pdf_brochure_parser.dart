import 'dart:io';
import 'package:meta/meta.dart';
import 'package:pdf_text/pdf_text.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/brochure_parser.dart';

class PdfBrochureParser implements BrochureParser {
  @override
  Future<List<Offer>> parse(File file, int brochureId) async {
    try {
      final PDFDoc doc = await PDFDoc.fromFile(file);
      final String text = await doc.text;
      
      // Initial simple parsing logic - will be improved in Phase 2 Task 3
      return extractOffersFromRawText(text, brochureId);
    } catch (e) {
      // For now, return empty list on error. Will be improved with custom exceptions.
      return [];
    }
  }

  @visibleForTesting
  List<Offer> extractOffersFromRawText(String text, int brochureId) {
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
    
    final lines = text.split('\n');
    int idCounter = 1;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final matches = priceRegex.allMatches(line);
      for (final match in matches) {
        final priceString = match.group(1)!.replaceAll(',', '.').replaceAll('-', '00');
        final double price = double.tryParse(priceString) ?? 0.0;
        
        if (price > 0) {
          // Heuristic: The product name is often in the same line before the price, 
          // or in the line immediately above.
          String productName = line.substring(0, match.start).trim();
          String? unit;

          // Check for unit in the current line
          final unitMatch = unitRegex.firstMatch(line);
          if (unitMatch != null) {
            unit = unitMatch.group(1)?.trim();
            // Remove unit from product name if it was caught there
            productName = productName.replaceFirst(unitMatch.group(1)!, '').trim();
          }
          
          if ((productName.isEmpty || productName.length < 3) && i > 0) {
            // Try previous line for product name
            productName = lines[i - 1].trim();
            
            // Check for unit in previous line if not found yet
            if (unit == null) {
              final prevUnitMatch = unitRegex.firstMatch(productName);
              if (prevUnitMatch != null) {
                unit = prevUnitMatch.group(1)?.trim();
                productName = productName.replaceFirst(prevUnitMatch.group(1)!, '').trim();
              }
            }
          }
          
          if (productName.isEmpty || productName.length < 3) {
            productName = "Unbekanntes Produkt";
          }

          // Clean up product name from dangling chars
          productName = productName.replaceAll(RegExp(r'^[^\w\d]+|[^\w\d]+$'), '').trim();

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
    
    return offers;
  }
}

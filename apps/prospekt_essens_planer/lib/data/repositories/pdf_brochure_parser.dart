import 'dart:io';
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
      return _extractOffersFromRawText(text, brochureId);
    } catch (e) {
      // For now, return empty list on error. Will be improved with custom exceptions.
      return [];
    }
  }

  List<Offer> _extractOffersFromRawText(String text, int brochureId) {
    final List<Offer> offers = [];
    
    // Very basic regex to find price-like patterns (e.g., 1.99, 1,99, 0.45)
    // This is a placeholder for the more advanced logic in Task 3.
    final RegExp priceRegex = RegExp(r'(\d+[\.,]\d{2})');
    final matches = priceRegex.allMatches(text);
    
    int idCounter = 1;
    for (final match in matches) {
      final priceString = match.group(0)!.replaceAll(',', '.');
      final double price = double.tryParse(priceString) ?? 0.0;
      
      // Placeholder: In a real scenario, we'd look for the product name *near* the price.
      offers.add(Offer(
        id: idCounter++,
        brochureId: brochureId,
        productName: "Unbekanntes Produkt (Raw Extraction)",
        price: price,
      ));
    }
    
    return offers;
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:prospekt_core/prospekt_core.dart';

class PdfBrochureParser implements BrochureParser {
  static const _channel = MethodChannel('com.violen.prospekt_essens_planer/pdf_extractor');

  @override
  Future<List<Offer>> parse(File file, int brochureId) async {
    try {
      final String? text = await _channel.invokeMethod<String>('extractText', {
        'filePath': file.path,
      });
      
      if (text == null || text.isEmpty) return [];
      
      return extractOffersFromRawText(text, brochureId);
    } catch (e) {
      // In a real app, we'd log this and throw a custom exception
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

    // Regex for common units: kg, g, l, ml, Stück, St., Dose, Packung, Pck.
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
          String productName = line.substring(0, match.start).trim();
          String? unit;

          final unitMatch = unitRegex.firstMatch(line);
          if (unitMatch != null) {
            unit = unitMatch.group(1)?.trim();
            productName = productName.replaceFirst(unitMatch.group(1)!, '').trim();
          }
          
          if ((productName.isEmpty || productName.length < 3) && i > 0) {
            productName = lines[i - 1].trim();
            
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

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:prospekt_core/prospekt_core.dart';

class PdfBrochureParser implements BrochureParser {
  static const _channel = MethodChannel('com.violen.prospekt_essens_planer/pdf_extractor');
  final ProductClassifier _classifier = ProductClassifier();
  final IngredientNormalizer _normalizer = IngredientNormalizer();

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
    
    // Main price regex: 1,99 | 1.99 | 1,- | 1.00 €
    final RegExp exactPriceRegex = RegExp(
      r'^(\d{1,3}[\.,](\d{2}|-))\s*€?$',
      caseSensitive: false,
    );

    // Regex to detect base prices to ignore them: e.g. (1 kg = 4.00)
    final RegExp basePriceRegex = RegExp(r'\(\s*\d+.*=\s*\d+[\.,]\d{2}\s*\)');

    // Regex for common units
    final RegExp unitRegex = RegExp(
      r'(\b\d*[\.,]?\d*\s*(?:kg|g|l|ml|Stück|St\.?|Dose|Packung|Pck\.?|Fl\.?|Flasche)\b)',
      caseSensitive: false,
    );
    
    final List<String> blacklistWords = [
      'pfand', 'koffeinhaltig', 'inkl', 'mwst', 'pro', 'je', 'ca', 'ab', 'nur', 'statt', 'aus', 'unserer', 'knüller', 'aktion', 'billiger', 'rabatt', 'superpreis', 'dauerhaft', 'versch.', 'sorten', 'angebote', 'gültig'
    ];

    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    int idCounter = 1;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Ignore base prices like (1 l = 4.00) completely
      if (basePriceRegex.hasMatch(line)) continue;

      // Extract price if the line is purely a price or "nur X.XX"
      double price = 0.0;
      String priceCandidate = line;
      if (line.toLowerCase().startsWith('nur ')) {
        priceCandidate = line.substring(4).trim();
      }

      final priceMatch = exactPriceRegex.firstMatch(priceCandidate);
      if (priceMatch != null) {
        final priceString = priceMatch.group(1)!.replaceAll(',', '.').replaceAll('-', '00');
        price = double.tryParse(priceString) ?? 0.0;
      }

      if (price > 0) {
        // We found a price! Now let's look upwards to find the product name and unit.
        String productName = "";
        String? unit;
        
        // Look back up to 8 lines
        for (int j = i - 1; j >= 0 && j >= i - 8; j--) {
          String prevLine = lines[j];
          
          // Skip if it's a base price or a discount like "-42%"
          if (basePriceRegex.hasMatch(prevLine) || 
              RegExp(r'^-\d+%$').hasMatch(prevLine)) {
            continue;
          }

          // Break if we hit another price line, as it marks the boundary of the next offer context
          if (exactPriceRegex.hasMatch(prevLine)) {
            break;
          }

          // Check if this line contains a unit
          final unitMatch = unitRegex.firstMatch(prevLine);
          if (unitMatch != null && unit == null) {
            unit = unitMatch.group(1)?.trim();
            // Don't use the pure unit line as product name
            prevLine = prevLine.replaceFirst(unitMatch.group(1)!, '').trim();
            if (prevLine.isEmpty || RegExp(r'^[\W_]+$').hasMatch(prevLine)) {
                continue;
            }
          }

          final lowerLine = prevLine.toLowerCase();
          
          // Check blacklist
          bool isBlacklisted = false;
          for (final word in blacklistWords) {
            if (lowerLine == word || lowerLine.startsWith('$word ') || lowerLine.endsWith(' $word')) {
              isBlacklisted = true;
              break;
            }
          }
          if (isBlacklisted) continue;

          // Skip purely numeric/symbol lines
          if (RegExp(r'^[\d\s\.,|\+\-\*/%]+$').hasMatch(prevLine)) continue;
          
          if (prevLine.length >= 3) {
            // We likely found the product name! Let's prepend it (since we are reading backwards, 
            // we might want to capture multi-line names, but for now we take the first valid line we find upwards).
            // Actually, multi-line names: let's just combine the last 2 valid lines.
            if (productName.isEmpty) {
               productName = prevLine;
            } else {
               // We already found a name line, maybe this is the brand above it?
               productName = "$prevLine $productName";
               break; // Stop after 2 valid name lines
            }
          }
        }

        if (productName.isNotEmpty) {
          // Clean up dangling chars
          productName = productName.replaceAll(RegExp(r'^[^\w\däöüÄÖÜß]+|[^\w\däöüÄÖÜß]+$'), '').trim();

          // Deduplicate and classify offers
          if (!offers.any((o) => o.productName == productName && o.price == price)) {
            final category = _classifier.classify(productName, unit);
            
            // Only keep food or unknown items
            if (category == ProductCategory.food || category == ProductCategory.unknown) {
              final normalizedName = _normalizer.normalize(productName);
              final isReadyMeal = _normalizer.isReadyMeal(productName);

              offers.add(Offer(
                id: idCounter++,
                brochureId: brochureId,
                productName: productName,
                price: price,
                unit: unit,
                normalizedName: normalizedName,
                isReadyMeal: isReadyMeal,
              ));
            }
          }
        }
      }
    }
    
    return offers;
  }
}

import 'dart:io';
import 'package:path/path.dart' as p;
import '../../domain/entities/offer.dart';
import '../../domain/repositories/brochure_parser.dart';
import 'pdf_brochure_parser.dart';
import 'ocr_brochure_parser.dart';

class CompositeBrochureParser implements BrochureParser {
  final PdfBrochureParser _pdfParser;
  final OcrBrochureParser _ocrParser;

  CompositeBrochureParser(this._pdfParser, this._ocrParser);

  @override
  Future<List<Offer>> parse(File file, int brochureId) async {
    final extension = p.extension(file.path).toLowerCase();
    
    if (extension == '.pdf') {
      return _pdfParser.parse(file, brochureId);
    } else if (['.jpg', '.jpeg', '.png', '.webp'].contains(extension)) {
      return _ocrParser.parse(file, brochureId);
    } else {
      // Unsupported format
      return [];
    }
  }
}

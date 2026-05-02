import 'dart:io';
import '../entities/offer.dart';

abstract class BrochureParser {
  /// Parses a brochure file (PDF or Image) and returns a list of extracted offers.
  /// 
  /// The [file] is the brochure document to parse.
  /// The [brochureId] is the ID of the brochure in the database to associate the offers with.
  Future<List<Offer>> parse(File file, int brochureId);
}

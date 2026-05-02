// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Prospekt Essens Planer';

  @override
  String get importBrochure => 'Prospekt Importieren';

  @override
  String get selectFile => 'Datei auswählen (PDF/Bild)';

  @override
  String offersFound(int count) {
    return '$count Angebote gefunden';
  }

  @override
  String get saveOffers => 'Angebote Speichern';

  @override
  String get saveBrochure => 'Prospekt speichern';

  @override
  String get brochureName => 'Name des Prospekts (z.B. Kaufland KW 18)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get noFileSelected =>
      'Wähle ein Prospekt aus, um Angebote zu extrahieren.';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }
}

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
  String get takePhoto => 'Foto aufnehmen';

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

  @override
  String get deleteOffer => 'Angebot löschen';

  @override
  String get editOffer => 'Angebot bearbeiten';

  @override
  String get productName => 'Produktname';

  @override
  String get price => 'Preis';

  @override
  String get apply => 'Übernehmen';

  @override
  String get refreshRecommendations => 'Empfehlungen aktualisieren';

  @override
  String get searchingRecommendations => 'Suche nach passenden Rezepten...';

  @override
  String get processingBrochure => 'Verarbeite Prospekt...';

  @override
  String get onOffer => 'Im Angebot';

  @override
  String get noOfferFound => 'Kein Angebot gefunden';

  @override
  String matchPercentage(String percent) {
    return 'Übereinstimmung: $percent Prozent';
  }

  @override
  String savingsAmount(String amount) {
    return 'Ersparnis: $amount Euro';
  }

  @override
  String get noRecommendationsTitle => 'Noch keine Empfehlungen';

  @override
  String get noRecommendationsMessage =>
      'Importiere ein Prospekt oder erstelle Rezepte, um personalisierte Essensvorschläge zu erhalten.';

  @override
  String get readyToImportTitle => 'Bereit zum Import';

  @override
  String get selectFileAction => 'Datei wählen';
}

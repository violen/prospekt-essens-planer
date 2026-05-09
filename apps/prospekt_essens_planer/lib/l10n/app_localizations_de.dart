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

  @override
  String get manageRecipes => 'Rezepte Verwalten';

  @override
  String get noRecipesTitle => 'Keine Rezepte';

  @override
  String get noRecipesMessage =>
      'Füge deine ersten Rezepte hinzu, um den Planer zu nutzen.';

  @override
  String get createRecipe => 'Rezept erstellen';

  @override
  String get newRecipe => 'Neues Rezept';

  @override
  String get dishName => 'Name des Gerichts';

  @override
  String get convenienceProduct => 'Convenience (Knorr/Maggi)';

  @override
  String get freshCooking => 'Frisch kochen';

  @override
  String get create => 'Erstellen';

  @override
  String get addIngredients => 'Zutaten hinzufügen';

  @override
  String get searchIngredient => 'Zutat suchen (z.B. Kartoffel)...';

  @override
  String get readyMeal => 'Fertiggericht';

  @override
  String get startTutorial => 'Tutorial starten';

  @override
  String get tutorialSkip => 'ÜBERSPRINGEN';

  @override
  String get tutorialImportTitle => '1. Prospekte Importieren';

  @override
  String get tutorialImportContent =>
      'Hier fängst du an! Lade PDF-Prospekte oder Fotos hoch, um aktuelle Angebote zu sammeln.';

  @override
  String get tutorialRecipesTitle => '2. Rezepte Verwalten';

  @override
  String get tutorialRecipesContent =>
      'Pflege hier deine Lieblingsgerichte und deren Zutaten ein.';

  @override
  String get tutorialSuggestionsTitle => '3. Intelligente Vorschläge';

  @override
  String get tutorialSuggestionsContent =>
      'Die Magie passiert hier! Wir vergleichen deine Rezepte mit den Angeboten und zeigen dir, was du heute günstig kochen kannst.';

  @override
  String get tutorialPlannerTitle => '4. Wochenplaner';

  @override
  String get tutorialPlannerContent =>
      'Strukturiere deine Woche und spare bares Geld beim Kochen.';

  @override
  String get planer => 'Planer';

  @override
  String get suggestions => 'Vorschläge';

  @override
  String get recipes => 'Rezepte';

  @override
  String get import => 'Import';

  @override
  String get weeklyPlanner => 'Wochenplaner';

  @override
  String kwPrefix(String week) {
    return 'KW $week';
  }

  @override
  String get lunch => 'Mittagessen';

  @override
  String get dinner => 'Abendessen';

  @override
  String get nothingPlanned => 'Noch nichts geplant';

  @override
  String get loadingRecipe => 'Lade Rezept...';

  @override
  String get unknown => 'Unbekannt';

  @override
  String scheduleMeal(String recipe) {
    return '$recipe einplanen';
  }

  @override
  String get schedule => 'Einplanen';

  @override
  String get mealTimeSelection => 'Mittag- oder Abendessen';
}

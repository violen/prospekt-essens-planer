import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de')];

  /// Der Titel der Anwendung
  ///
  /// In de, this message translates to:
  /// **'Prospekt Essens Planer'**
  String get appTitle;

  /// Titel der Import-Seite
  ///
  /// In de, this message translates to:
  /// **'Prospekt Importieren'**
  String get importBrochure;

  /// No description provided for @selectFile.
  ///
  /// In de, this message translates to:
  /// **'Datei auswählen (PDF/Bild)'**
  String get selectFile;

  /// No description provided for @takePhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto aufnehmen'**
  String get takePhoto;

  /// No description provided for @offersFound.
  ///
  /// In de, this message translates to:
  /// **'{count} Angebote gefunden'**
  String offersFound(int count);

  /// No description provided for @saveOffers.
  ///
  /// In de, this message translates to:
  /// **'Angebote Speichern'**
  String get saveOffers;

  /// No description provided for @saveBrochure.
  ///
  /// In de, this message translates to:
  /// **'Prospekt speichern'**
  String get saveBrochure;

  /// No description provided for @brochureName.
  ///
  /// In de, this message translates to:
  /// **'Name des Prospekts (z.B. Kaufland KW 18)'**
  String get brochureName;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @noFileSelected.
  ///
  /// In de, this message translates to:
  /// **'Wähle ein Prospekt aus, um Angebote zu extrahieren.'**
  String get noFileSelected;

  /// No description provided for @errorPrefix.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {message}'**
  String errorPrefix(String message);

  /// No description provided for @deleteOffer.
  ///
  /// In de, this message translates to:
  /// **'Angebot löschen'**
  String get deleteOffer;

  /// No description provided for @editOffer.
  ///
  /// In de, this message translates to:
  /// **'Angebot bearbeiten'**
  String get editOffer;

  /// No description provided for @productName.
  ///
  /// In de, this message translates to:
  /// **'Produktname'**
  String get productName;

  /// No description provided for @price.
  ///
  /// In de, this message translates to:
  /// **'Preis'**
  String get price;

  /// No description provided for @apply.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get apply;

  /// No description provided for @refreshRecommendations.
  ///
  /// In de, this message translates to:
  /// **'Empfehlungen aktualisieren'**
  String get refreshRecommendations;

  /// No description provided for @searchingRecommendations.
  ///
  /// In de, this message translates to:
  /// **'Suche nach passenden Rezepten...'**
  String get searchingRecommendations;

  /// No description provided for @processingBrochure.
  ///
  /// In de, this message translates to:
  /// **'Verarbeite Prospekt...'**
  String get processingBrochure;

  /// No description provided for @onOffer.
  ///
  /// In de, this message translates to:
  /// **'Im Angebot'**
  String get onOffer;

  /// No description provided for @noOfferFound.
  ///
  /// In de, this message translates to:
  /// **'Kein Angebot gefunden'**
  String get noOfferFound;

  /// No description provided for @matchPercentage.
  ///
  /// In de, this message translates to:
  /// **'Übereinstimmung: {percent} Prozent'**
  String matchPercentage(String percent);

  /// No description provided for @savingsAmount.
  ///
  /// In de, this message translates to:
  /// **'Ersparnis: {amount} Euro'**
  String savingsAmount(String amount);

  /// No description provided for @noRecommendationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Empfehlungen'**
  String get noRecommendationsTitle;

  /// No description provided for @noRecommendationsMessage.
  ///
  /// In de, this message translates to:
  /// **'Importiere ein Prospekt oder erstelle Rezepte, um personalisierte Essensvorschläge zu erhalten.'**
  String get noRecommendationsMessage;

  /// No description provided for @readyToImportTitle.
  ///
  /// In de, this message translates to:
  /// **'Bereit zum Import'**
  String get readyToImportTitle;

  /// No description provided for @selectFileAction.
  ///
  /// In de, this message translates to:
  /// **'Datei wählen'**
  String get selectFileAction;

  /// No description provided for @manageRecipes.
  ///
  /// In de, this message translates to:
  /// **'Rezepte Verwalten'**
  String get manageRecipes;

  /// No description provided for @noRecipesTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Rezepte'**
  String get noRecipesTitle;

  /// No description provided for @noRecipesMessage.
  ///
  /// In de, this message translates to:
  /// **'Füge deine ersten Rezepte hinzu, um den Planer zu nutzen.'**
  String get noRecipesMessage;

  /// No description provided for @createRecipe.
  ///
  /// In de, this message translates to:
  /// **'Rezept erstellen'**
  String get createRecipe;

  /// No description provided for @newRecipe.
  ///
  /// In de, this message translates to:
  /// **'Neues Rezept'**
  String get newRecipe;

  /// No description provided for @dishName.
  ///
  /// In de, this message translates to:
  /// **'Name des Gerichts'**
  String get dishName;

  /// No description provided for @convenienceProduct.
  ///
  /// In de, this message translates to:
  /// **'Convenience (Knorr/Maggi)'**
  String get convenienceProduct;

  /// No description provided for @freshCooking.
  ///
  /// In de, this message translates to:
  /// **'Frisch kochen'**
  String get freshCooking;

  /// No description provided for @create.
  ///
  /// In de, this message translates to:
  /// **'Erstellen'**
  String get create;

  /// No description provided for @addIngredients.
  ///
  /// In de, this message translates to:
  /// **'Zutaten hinzufügen'**
  String get addIngredients;

  /// No description provided for @searchIngredient.
  ///
  /// In de, this message translates to:
  /// **'Zutat suchen (z.B. Kartoffel)...'**
  String get searchIngredient;

  /// No description provided for @readyMeal.
  ///
  /// In de, this message translates to:
  /// **'Fertiggericht'**
  String get readyMeal;

  /// No description provided for @startTutorial.
  ///
  /// In de, this message translates to:
  /// **'Tutorial starten'**
  String get startTutorial;

  /// No description provided for @tutorialSkip.
  ///
  /// In de, this message translates to:
  /// **'ÜBERSPRINGEN'**
  String get tutorialSkip;

  /// No description provided for @tutorialImportTitle.
  ///
  /// In de, this message translates to:
  /// **'1. Prospekte Importieren'**
  String get tutorialImportTitle;

  /// No description provided for @tutorialImportContent.
  ///
  /// In de, this message translates to:
  /// **'Hier fängst du an! Lade PDF-Prospekte oder Fotos hoch, um aktuelle Angebote zu sammeln.'**
  String get tutorialImportContent;

  /// No description provided for @tutorialRecipesTitle.
  ///
  /// In de, this message translates to:
  /// **'2. Rezepte Verwalten'**
  String get tutorialRecipesTitle;

  /// No description provided for @tutorialRecipesContent.
  ///
  /// In de, this message translates to:
  /// **'Pflege hier deine Lieblingsgerichte und deren Zutaten ein.'**
  String get tutorialRecipesContent;

  /// No description provided for @tutorialSuggestionsTitle.
  ///
  /// In de, this message translates to:
  /// **'3. Intelligente Vorschläge'**
  String get tutorialSuggestionsTitle;

  /// No description provided for @tutorialSuggestionsContent.
  ///
  /// In de, this message translates to:
  /// **'Die Magie passiert hier! Wir vergleichen deine Rezepte mit den Angeboten und zeigen dir, was du heute günstig kochen kannst.'**
  String get tutorialSuggestionsContent;

  /// No description provided for @tutorialPlannerTitle.
  ///
  /// In de, this message translates to:
  /// **'4. Wochenplaner'**
  String get tutorialPlannerTitle;

  /// No description provided for @tutorialPlannerContent.
  ///
  /// In de, this message translates to:
  /// **'Strukturiere deine Woche und spare bares Geld beim Kochen.'**
  String get tutorialPlannerContent;

  /// No description provided for @planer.
  ///
  /// In de, this message translates to:
  /// **'Planer'**
  String get planer;

  /// No description provided for @suggestions.
  ///
  /// In de, this message translates to:
  /// **'Vorschläge'**
  String get suggestions;

  /// No description provided for @recipes.
  ///
  /// In de, this message translates to:
  /// **'Rezepte'**
  String get recipes;

  /// No description provided for @import.
  ///
  /// In de, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @weeklyPlanner.
  ///
  /// In de, this message translates to:
  /// **'Wochenplaner'**
  String get weeklyPlanner;

  /// No description provided for @kwPrefix.
  ///
  /// In de, this message translates to:
  /// **'KW {week}'**
  String kwPrefix(String week);

  /// No description provided for @lunch.
  ///
  /// In de, this message translates to:
  /// **'Mittagessen'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In de, this message translates to:
  /// **'Abendessen'**
  String get dinner;

  /// No description provided for @nothingPlanned.
  ///
  /// In de, this message translates to:
  /// **'Noch nichts geplant'**
  String get nothingPlanned;

  /// No description provided for @loadingRecipe.
  ///
  /// In de, this message translates to:
  /// **'Lade Rezept...'**
  String get loadingRecipe;

  /// No description provided for @unknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get unknown;

  /// No description provided for @scheduleMeal.
  ///
  /// In de, this message translates to:
  /// **'{recipe} einplanen'**
  String scheduleMeal(String recipe);

  /// No description provided for @schedule.
  ///
  /// In de, this message translates to:
  /// **'Einplanen'**
  String get schedule;

  /// No description provided for @mealTimeSelection.
  ///
  /// In de, this message translates to:
  /// **'Mittag- oder Abendessen'**
  String get mealTimeSelection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

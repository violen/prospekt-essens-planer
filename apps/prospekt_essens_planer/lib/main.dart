import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'l10n/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/services/preferences_service.dart';
import 'core/presentation/theme.dart';
import 'core/presentation/controllers/tutorial_controller.dart';
import 'features/brochure_ingestion/presentation/pages/brochure_ingestion_page.dart';
import 'features/meal_planner/presentation/pages/meal_planner_page.dart';
import 'features/meal_planner/presentation/pages/weekly_planner_page.dart';
import 'features/meal_planner/presentation/pages/recipe_management_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de', null);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(PreferencesService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Prospekt Essens Planer',
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;
  late TutorialCoachMark tutorialCoachMark;
  
  final GlobalKey _plannerKey = GlobalKey();
  final GlobalKey _suggestionsKey = GlobalKey();
  final GlobalKey _recipesKey = GlobalKey();
  final GlobalKey _importKey = GlobalKey();

  final List<Widget> _pages = [
    const WeeklyPlannerPage(),
    const MealPlannerPage(),
    const RecipeManagementPage(),
    const BrochureIngestionPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  void _checkAndShowTutorial() {
    final tutorialState = ref.read(tutorialControllerProvider);
    if (tutorialState.showTutorial) {
      _showTutorial();
      ref.read(tutorialControllerProvider.notifier).acknowledgeTutorialTrigger();
    }
  }

  void _showTutorial() {
    final l10n = AppLocalizations.of(context)!;
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(l10n),
      colorShadow: Theme.of(context).colorScheme.primary,
      textSkip: l10n.tutorialSkip,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () => ref.read(tutorialControllerProvider.notifier).completeTutorial(),
      onSkip: () {
        ref.read(tutorialControllerProvider.notifier).completeTutorial();
        return true;
      },
    )..show(context: context);
  }

  List<TargetFocus> _createTargets(AppLocalizations l10n) {
    return [
      TargetFocus(
        identify: "import",
        keyTarget: _importKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tutorialImportTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tutorialImportContent,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "recipes",
        keyTarget: _recipesKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tutorialRecipesTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tutorialRecipesContent,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "suggestions",
        keyTarget: _suggestionsKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tutorialSuggestionsTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tutorialSuggestionsContent,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "planner",
        keyTarget: _plannerKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tutorialPlannerTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tutorialPlannerContent,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Listen for manual tutorial restart
    ref.listen(tutorialControllerProvider, (previous, next) {
      if (next.showTutorial && !(previous?.showTutorial ?? false)) {
        _showTutorial();
        ref.read(tutorialControllerProvider.notifier).acknowledgeTutorialTrigger();
      }
    });

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined, key: _plannerKey),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.planer,
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined, key: _suggestionsKey),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: l10n.suggestions,
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, key: _recipesKey),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.recipes,
          ),
          NavigationDestination(
            icon: Icon(Icons.file_upload_outlined, key: _importKey),
            selectedIcon: const Icon(Icons.file_upload),
            label: l10n.import,
          ),
        ],
      ),
    );
  }
}

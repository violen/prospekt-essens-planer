import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/preferences_service.dart';

class TutorialState {
  final bool showTutorial;

  TutorialState({this.showTutorial = false});

  TutorialState copyWith({bool? showTutorial}) {
    return TutorialState(showTutorial: showTutorial ?? this.showTutorial);
  }
}

final tutorialControllerProvider = StateNotifierProvider<TutorialController, TutorialState>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return TutorialController(prefsService);
});

class TutorialController extends StateNotifier<TutorialState> {
  final PreferencesService _prefsService;

  TutorialController(this._prefsService) : super(TutorialState()) {
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() {
    final hasSeen = _prefsService.hasSeenTutorial();
    if (!hasSeen) {
      state = state.copyWith(showTutorial: true);
    }
  }

  Future<void> completeTutorial() async {
    await _prefsService.setHasSeenTutorial(true);
    state = state.copyWith(showTutorial: false);
  }

  void restartTutorial() {
    state = state.copyWith(showTutorial: true);
  }

  void acknowledgeTutorialTrigger() {
    state = state.copyWith(showTutorial: false);
  }
}

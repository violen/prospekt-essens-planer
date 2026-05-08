import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('preferencesServiceProvider must be overridden in main.dart');
});

class PreferencesService {
  final SharedPreferences _prefs;
  static const _hasSeenTutorialKey = 'has_seen_tutorial';

  PreferencesService(this._prefs);

  bool hasSeenTutorial() {
    return _prefs.getBool(_hasSeenTutorialKey) ?? false;
  }

  Future<void> setHasSeenTutorial(bool seen) async {
    await _prefs.setBool(_hasSeenTutorialKey, seen);
  }
}

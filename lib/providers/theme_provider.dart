import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/app_preferences.dart';

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final saved = await AppPreferences.getThemeIsDark();
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> toggleTheme() async {
    final nextValue = !state;
    state = nextValue;
    await AppPreferences.setThemeIsDark(nextValue);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (ref) => ThemeModeNotifier(),
);

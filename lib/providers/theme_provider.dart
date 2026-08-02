import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/keyboard_theme.dart';
import '../core/services/storage_service.dart';

class ThemeState {
  final KeyboardThemeData activeTheme;
  final List<KeyboardThemeData> customThemes;

  const ThemeState({
    required this.activeTheme,
    this.customThemes = const [],
  });

  ThemeState copyWith({
    KeyboardThemeData? activeTheme,
    List<KeyboardThemeData>? customThemes,
  }) {
    return ThemeState(
      activeTheme: activeTheme ?? this.activeTheme,
      customThemes: customThemes ?? this.customThemes,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(activeTheme: StorageService.getActiveTheme())) {
    loadCustomThemes();
  }

  void loadCustomThemes() {
    final custom = StorageService.getCustomThemes();
    state = state.copyWith(customThemes: custom);
  }

  void setTheme(KeyboardThemeData theme) async {
    state = state.copyWith(activeTheme: theme);
    await StorageService.saveActiveTheme(theme);
  }

  void saveCustomTheme(KeyboardThemeData theme) async {
    await StorageService.saveCustomTheme(theme);
    setTheme(theme);
    loadCustomThemes();
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

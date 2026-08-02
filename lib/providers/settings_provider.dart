import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/storage_service.dart';

class SettingsState {
  final double keyboardHeightFactor;
  final int soundType;
  final int hapticStrength;
  final bool autoCapitalization;
  final bool batterySaverMode;

  const SettingsState({
    this.keyboardHeightFactor = 1.0,
    this.soundType = 1,
    this.hapticStrength = 20,
    this.autoCapitalization = true,
    this.batterySaverMode = false,
  });

  SettingsState copyWith({
    double? keyboardHeightFactor,
    int? soundType,
    int? hapticStrength,
    bool? autoCapitalization,
    bool? batterySaverMode,
  }) {
    return SettingsState(
      keyboardHeightFactor: keyboardHeightFactor ?? this.keyboardHeightFactor,
      soundType: soundType ?? this.soundType,
      hapticStrength: hapticStrength ?? this.hapticStrength,
      autoCapitalization: autoCapitalization ?? this.autoCapitalization,
      batterySaverMode: batterySaverMode ?? this.batterySaverMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(
    keyboardHeightFactor: StorageService.getKeyboardHeightFactor(),
    soundType: StorageService.getSoundType(),
    hapticStrength: StorageService.getHapticStrength(),
    autoCapitalization: StorageService.getAutoCapitalization(),
  ));

  void setKeyboardHeight(double factor) async {
    state = state.copyWith(keyboardHeightFactor: factor);
    await StorageService.setKeyboardHeightFactor(factor);
  }

  void setSoundType(int type) async {
    state = state.copyWith(soundType: type);
    await StorageService.setSoundType(type);
  }

  void setHapticStrength(int ms) async {
    state = state.copyWith(hapticStrength: ms);
    await StorageService.setHapticStrength(ms);
  }

  void setAutoCapitalization(bool value) async {
    state = state.copyWith(autoCapitalization: value);
    await StorageService.setAutoCapitalization(value);
  }

  void toggleBatterySaver(bool value) {
    state = state.copyWith(batterySaverMode: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

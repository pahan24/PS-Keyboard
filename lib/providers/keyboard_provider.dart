import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/native_input_service.dart';
import '../core/services/sinhala_converter_service.dart';

enum KeyboardLayoutMode {
  english,
  sinhalaPhonetic,
  sinhalaWijesekera,
  numeric,
  symbol
}

enum ShiftState { off, single, capsLock }

enum ActivePanel {
  none,
  secretEncoder,
  clipboard,
  emojis,
  textTools,
  translation,
  aiTemplates,
  themeCustomizer,
  settings
}

class KeyboardState {
  final KeyboardLayoutMode layoutMode;
  final ShiftState shiftState;
  final ActivePanel activePanel;
  final String phoneticBuffer;
  final List<String> suggestions;

  const KeyboardState({
    this.layoutMode = KeyboardLayoutMode.english,
    this.shiftState = ShiftState.off,
    this.activePanel = ActivePanel.none,
    this.phoneticBuffer = '',
    this.suggestions = const [],
  });

  KeyboardState copyWith({
    KeyboardLayoutMode? layoutMode,
    ShiftState? shiftState,
    ActivePanel? activePanel,
    String? phoneticBuffer,
    List<String>? suggestions,
  }) {
    return KeyboardState(
      layoutMode: layoutMode ?? this.layoutMode,
      shiftState: shiftState ?? this.shiftState,
      activePanel: activePanel ?? this.activePanel,
      phoneticBuffer: phoneticBuffer ?? this.phoneticBuffer,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class KeyboardNotifier extends StateNotifier<KeyboardState> {
  KeyboardNotifier() : super(const KeyboardState());

  void setLayoutMode(KeyboardLayoutMode mode) {
    state = state.copyWith(layoutMode: mode, activePanel: ActivePanel.none);
  }

  void togglePanel(ActivePanel panel) {
    if (state.activePanel == panel) {
      state = state.copyWith(activePanel: ActivePanel.none);
    } else {
      state = state.copyWith(activePanel: panel);
    }
  }

  void toggleShift() {
    if (state.shiftState == ShiftState.off) {
      state = state.copyWith(shiftState: ShiftState.single);
    } else if (state.shiftState == ShiftState.single) {
      state = state.copyWith(shiftState: ShiftState.capsLock);
    } else {
      state = state.copyWith(shiftState: ShiftState.off);
    }
  }

  void handleKeyTap(String keyChar) async {
    if (state.layoutMode == KeyboardLayoutMode.sinhalaPhonetic) {
      final newBuffer = state.phoneticBuffer + keyChar;
      final sinhalaText = SinhalaConverterService.convertPhonetic(newBuffer);
      state = state.copyWith(
        phoneticBuffer: newBuffer,
        suggestions: [sinhalaText, newBuffer],
      );
      await NativeInputService.commitText(keyChar);
    } else {
      String charToCommit = keyChar;
      if (state.shiftState != ShiftState.off) {
        charToCommit = keyChar.toUpperCase();
        if (state.shiftState == ShiftState.single) {
          state = state.copyWith(shiftState: ShiftState.off);
        }
      }
      await NativeInputService.commitText(charToCommit);
    }
  }

  void handleDelete() async {
    if (state.phoneticBuffer.isNotEmpty) {
      final newBuffer = state.phoneticBuffer.substring(0, state.phoneticBuffer.length - 1);
      final sinhalaText = SinhalaConverterService.convertPhonetic(newBuffer);
      state = state.copyWith(
        phoneticBuffer: newBuffer,
        suggestions: newBuffer.isEmpty ? [] : [sinhalaText, newBuffer],
      );
    }
    await NativeInputService.deleteSurroundingText();
  }

  void handleSpace() async {
    state = state.copyWith(phoneticBuffer: '', suggestions: []);
    await NativeInputService.commitText(' ');
  }

  void handleReturn() async {
    state = state.copyWith(phoneticBuffer: '', suggestions: []);
    await NativeInputService.sendKeyEvent(66); // KeyCode 66: Enter
  }
}

final keyboardProvider = StateNotifierProvider<KeyboardNotifier, KeyboardState>((ref) {
  return KeyboardNotifier();
});

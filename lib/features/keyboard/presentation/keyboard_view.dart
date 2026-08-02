import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/keyboard_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/settings_provider.dart';
import 'widgets/live_background_widget.dart';
import 'keyboard_toolbar.dart';
import 'layouts/english_layout.dart';
import 'layouts/sinhala_phonetic_layout.dart';
import 'layouts/sinhala_wijesekera_layout.dart';
import 'layouts/numeric_symbol_layout.dart';
import 'panels/secret_encoder_panel.dart';
import 'panels/clipboard_panel.dart';
import 'panels/emoji_panel.dart';
import 'panels/text_tools_panel.dart';
import 'panels/translation_panel.dart';
import 'panels/ai_templates_panel.dart';
import '../../main_app/theme_customizer_screen.dart';

class KeyboardView extends ConsumerWidget {
  const KeyboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).activeTheme;
    final state = ref.watch(keyboardProvider);
    final settings = ref.watch(settingsProvider);

    Widget layoutWidget;
    switch (state.layoutMode) {
      case KeyboardLayoutMode.english:
        layoutWidget = const EnglishLayout();
        break;
      case KeyboardLayoutMode.sinhalaPhonetic:
        layoutWidget = const SinhalaPhoneticLayout();
        break;
      case KeyboardLayoutMode.sinhalaWijesekera:
        layoutWidget = const SinhalaWijesekeraLayout();
        break;
      case KeyboardLayoutMode.numeric:
      case KeyboardLayoutMode.symbol:
        layoutWidget = const NumericSymbolLayout();
        break;
    }

    Widget? panelWidget;
    switch (state.activePanel) {
      case ActivePanel.secretEncoder:
        panelWidget = const SecretEncoderPanel();
        break;
      case ActivePanel.clipboard:
        panelWidget = const ClipboardPanel();
        break;
      case ActivePanel.emojis:
        panelWidget = const EmojiPanel();
        break;
      case ActivePanel.textTools:
        panelWidget = const TextToolsPanel();
        break;
      case ActivePanel.translation:
        panelWidget = const TranslationPanel();
        break;
      case ActivePanel.aiTemplates:
        panelWidget = const AiTemplatesPanel();
        break;
      case ActivePanel.themeCustomizer:
        panelWidget = const SizedBox(
          height: 240,
          child: ThemeCustomizerScreen(isEmbedded: true),
        );
        break;
      default:
        panelWidget = null;
    }

    final totalHeight = (260 * settings.keyboardHeightFactor).clamp(200.0, 360.0);

    return Container(
      height: totalHeight,
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(theme.opacity),
      ),
      child: Stack(
        children: [
          // Live Background Shaders / RGB animations
          Positioned.fill(
            child: LiveBackgroundWidget(
              type: theme.liveBackground,
              isRgbAnimated: theme.isRgbAnimated,
              rgbSpeed: theme.rgbSpeed,
            ),
          ),

          // Main Keyboard Column
          Column(
            children: [
              const KeyboardToolbar(),
              Expanded(
                child: panelWidget ?? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                  child: layoutWidget,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

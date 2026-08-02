import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/keyboard_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/clipboard_provider.dart';
import '../../../providers/secret_encoder_provider.dart';
import '../../../core/services/native_input_service.dart';

class KeyboardToolbar extends ConsumerWidget {
  const KeyboardToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).activeTheme;
    final keyboardState = ref.watch(keyboardProvider);
    final keyboardNotifier = ref.read(keyboardProvider.notifier);
    final clipboardState = ref.watch(clipboardProvider);

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor.withOpacity(0.4),
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: [
          // If PSK detected in clipboard, show fast decode banner
          if (clipboardState.detectedPskText != null)
            _buildPskBanner(context, ref, theme, clipboardState.detectedPskText!),

          // Standard suggestions and quick action toolbar
          Expanded(
            child: Row(
              children: [
                // Suggestions List or Quick Action Buttons
                if (keyboardState.suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: keyboardState.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = keyboardState.suggestions[index];
                        return InkWell(
                          onTap: () {
                            NativeInputService.commitText(suggestion);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.accentColor),
                            ),
                            child: Center(
                              child: Text(
                                suggestion,
                                style: TextStyle(
                                  color: theme.keyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildIconButton(
                          icon: Icons.lock_outline,
                          tooltip: 'Secret Encoder',
                          active: keyboardState.activePanel == ActivePanel.secretEncoder,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.secretEncoder),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.content_paste_outlined,
                          tooltip: 'Clipboard Manager',
                          active: keyboardState.activePanel == ActivePanel.clipboard,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.clipboard),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.font_download_outlined,
                          tooltip: 'Fancy Text Tools',
                          active: keyboardState.activePanel == ActivePanel.textTools,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.textTools),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.translate_outlined,
                          tooltip: 'Translator',
                          active: keyboardState.activePanel == ActivePanel.translation,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.translation),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.emoji_emotions_outlined,
                          tooltip: 'Emojis & Symbols',
                          active: keyboardState.activePanel == ActivePanel.emojis,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.emojis),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.auto_awesome_outlined,
                          tooltip: 'AI Smart Templates',
                          active: keyboardState.activePanel == ActivePanel.aiTemplates,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.aiTemplates),
                          theme: theme,
                        ),
                        _buildIconButton(
                          icon: Icons.palette_outlined,
                          tooltip: 'Themes',
                          active: keyboardState.activePanel == ActivePanel.themeCustomizer,
                          onTap: () => keyboardNotifier.togglePanel(ActivePanel.themeCustomizer),
                          theme: theme,
                        ),
                      ],
                    ),
                  ),

                // Language Switch Pill
                _buildLanguageTogglePill(keyboardState, keyboardNotifier, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required bool active,
    required VoidCallback onTap,
    required dynamic theme,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: active ? theme.accentColor : theme.keyTextColor.withOpacity(0.7),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildLanguageTogglePill(
    KeyboardState state,
    KeyboardNotifier notifier,
    dynamic theme,
  ) {
    String label = 'EN';
    if (state.layoutMode == KeyboardLayoutMode.sinhalaPhonetic) {
      label = 'සි (Ph)';
    } else if (state.layoutMode == KeyboardLayoutMode.sinhalaWijesekera) {
      label = 'සි (Wij)';
    }

    return InkWell(
      onTap: () {
        if (state.layoutMode == KeyboardLayoutMode.english) {
          notifier.setLayoutMode(KeyboardLayoutMode.sinhalaPhonetic);
        } else if (state.layoutMode == KeyboardLayoutMode.sinhalaPhonetic) {
          notifier.setLayoutMode(KeyboardLayoutMode.sinhalaWijesekera);
        } else {
          notifier.setLayoutMode(KeyboardLayoutMode.english);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: theme.specialKeyColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: theme.specialKeyTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPskBanner(
    BuildContext context,
    WidgetRef ref,
    dynamic theme,
    String pskText,
  ) {
    return Container(
      color: theme.accentColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Icon(Icons.security, size: 14, color: theme.accentColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Encrypted Secret Detected in Clipboard!',
              style: TextStyle(color: theme.keyTextColor, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              ref.read(secretEncoderProvider.notifier).loadDetectedPsk(pskText);
              ref.read(keyboardProvider.notifier).togglePanel(ActivePanel.secretEncoder);
              ref.read(clipboardProvider.notifier).dismissPskBanner();
            },
            child: Text(
              'DECODE NOW',
              style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 14),
            onPressed: () {
              ref.read(clipboardProvider.notifier).dismissPskBanner();
            },
          ),
        ],
      ),
    );
  }
}

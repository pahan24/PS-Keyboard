import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class SettingsDetailScreen extends ConsumerWidget {
  const SettingsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Keyboard Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Keyboard Height
          ListTile(
            title: const Text('Keyboard Height'),
            subtitle: Text('${(settings.keyboardHeightFactor * 100).round()}%'),
          ),
          Slider(
            value: settings.keyboardHeightFactor,
            min: 0.8,
            max: 1.4,
            divisions: 6,
            onChanged: (val) => notifier.setKeyboardHeight(val),
          ),
          const Divider(),

          // Sound Scheme
          ListTile(
            title: const Text('Typing Sound Effect'),
            subtitle: Text(
              settings.soundType == 1
                  ? 'Mechanical Click'
                  : settings.soundType == 2
                      ? 'Vintage Typewriter'
                      : 'Soft Bubble',
            ),
            trailing: DropdownButton<int>(
              value: settings.soundType,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Mechanical')),
                DropdownMenuItem(value: 2, child: Text('Typewriter')),
                DropdownMenuItem(value: 3, child: Text('Soft Bubble')),
              ],
              onChanged: (val) {
                if (val != null) notifier.setSoundType(val);
              },
            ),
          ),
          const Divider(),

          // Haptic Strength
          ListTile(
            title: const Text('Vibration / Haptic Strength'),
            subtitle: Text('${settings.hapticStrength} ms'),
          ),
          Slider(
            value: settings.hapticStrength.toDouble(),
            min: 0,
            max: 50,
            divisions: 10,
            onChanged: (val) => notifier.setHapticStrength(val.round()),
          ),
          const Divider(),

          // Auto Capitalization
          SwitchListTile(
            title: const Text('Auto Capitalization'),
            subtitle: const Text('Automatically capitalize the first letter of sentences'),
            value: settings.autoCapitalization,
            onChanged: (val) => notifier.setAutoCapitalization(val),
          ),
          const Divider(),

          // Battery Saver Mode
          SwitchListTile(
            title: const Text('Low Battery Saver Mode'),
            subtitle: const Text('Disables live shaders and RGB wave animations to conserve power'),
            value: settings.batterySaverMode,
            onChanged: (val) => notifier.toggleBatterySaver(val),
          ),
        ],
      ),
    );
  }
}

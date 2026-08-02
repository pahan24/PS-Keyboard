import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../core/theme/keyboard_theme.dart';

class ThemeCustomizerScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const ThemeCustomizerScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<ThemeCustomizerScreen> createState() => _ThemeCustomizerScreenState();
}

class _ThemeCustomizerScreenState extends ConsumerState<ThemeCustomizerScreen> {
  late KeyboardThemeData _current;

  @override
  void initState() {
    super.initState();
    _current = ref.read(themeProvider).activeTheme;
  }

  void _updateTheme(KeyboardThemeData updated) {
    setState(() => _current = updated);
    ref.read(themeProvider.notifier).setTheme(updated);
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live Background Selector
          const Text('Live Background Animation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: LiveBackgroundType.values.map((type) {
              final isSel = _current.liveBackground == type;
              return ChoiceChip(
                label: Text(type.name, style: const TextStyle(fontSize: 11)),
                selected: isSel,
                onSelected: (val) {
                  if (val) _updateTheme(KeyboardThemeData.fromJson({..._current.toJson(), 'liveBackground': type.name}));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // RGB Animation Toggle
          SwitchListTile(
            title: const Text('Animated RGB Rainbow Wave', style: TextStyle(fontSize: 13)),
            value: _current.isRgbAnimated,
            onChanged: (val) {
              _updateTheme(KeyboardThemeData.fromJson({..._current.toJson(), 'isRgbAnimated': val}));
            },
          ),

          // Opacity Slider
          Text('Key Opacity: ${(_current.opacity * 100).round()}%', style: const TextStyle(fontSize: 12)),
          Slider(
            value: _current.opacity,
            min: 0.2,
            max: 1.0,
            onChanged: (val) {
              _updateTheme(KeyboardThemeData.fromJson({..._current.toJson(), 'opacity': val}));
            },
          ),

          // Border Radius Slider
          Text('Corner Radius: ${_current.borderRadius.round()}px', style: const TextStyle(fontSize: 12)),
          Slider(
            value: _current.borderRadius,
            min: 0.0,
            max: 20.0,
            onChanged: (val) {
              _updateTheme(KeyboardThemeData.fromJson({..._current.toJson(), 'borderRadius': val}));
            },
          ),

          // Export / Import JSON
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final jsonStr = jsonEncode(_current.toJson());
                    Clipboard.setData(ClipboardData(text: jsonStr));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Theme JSON copied to clipboard!')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Export JSON'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      try {
                        final map = jsonDecode(data!.text!) as Map<String, dynamic>;
                        final imported = KeyboardThemeData.fromJson(map);
                        _updateTheme(imported);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Theme successfully imported!')),
                        );
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: Invalid Theme JSON')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Import JSON'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (widget.isEmbedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme Builder')),
      body: body,
    );
  }
}

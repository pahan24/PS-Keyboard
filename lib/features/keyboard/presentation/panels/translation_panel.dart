import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/sinhala_converter_service.dart';
import '../../../../core/services/native_input_service.dart';

class TranslationPanel extends ConsumerStatefulWidget {
  const TranslationPanel({super.key});

  @override
  ConsumerState<TranslationPanel> createState() => _TranslationPanelState();
}

class _TranslationPanelState extends ConsumerState<TranslationPanel> {
  String _input = '';
  String _translation = '';
  bool _isEnToSi = true;

  void _translate() {
    if (_input.isEmpty) {
      setState(() => _translation = '');
      return;
    }
    if (_isEnToSi) {
      final converted = SinhalaConverterService.convertPhonetic(_input);
      setState(() => _translation = converted);
    } else {
      setState(() => _translation = _input);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).activeTheme;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEnToSi ? 'English ➔ Sinhala' : 'Sinhala ➔ English',
                style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              IconButton(
                icon: const Icon(Icons.swap_horiz, size: 20),
                onPressed: () {
                  setState(() {
                    _isEnToSi = !_isEnToSi;
                    _translate();
                  });
                },
              ),
            ],
          ),
          TextField(
            onChanged: (val) {
              _input = val;
              _translate();
            },
            style: TextStyle(color: theme.keyTextColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Type message to translate...',
              hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
              filled: true,
              fillColor: theme.keyColor,
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.keyColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _translation.isEmpty ? 'Translation will appear here...' : _translation,
                      style: TextStyle(
                        color: _translation.isEmpty
                            ? theme.keyTextColor.withOpacity(0.5)
                            : theme.keyTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_translation.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => NativeInputService.commitText(_translation),
                      icon: const Icon(Icons.send, size: 14),
                      label: const Text('Insert', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

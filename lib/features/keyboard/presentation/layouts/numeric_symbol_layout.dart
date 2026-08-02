import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../key_button.dart';
import '../../../../providers/keyboard_provider.dart';

class NumericSymbolLayout extends ConsumerStatefulWidget {
  const NumericSymbolLayout({super.key});

  @override
  ConsumerState<NumericSymbolLayout> createState() => _NumericSymbolLayoutState();
}

class _NumericSymbolLayoutState extends ConsumerState<NumericSymbolLayout> {
  bool _isPage2 = false;

  static const List<String> numRow1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  static const List<String> symRow2Page1 = ['@', '#', '\$', '_', '&', '-', '+', '(', ')', '/'];
  static const List<String> symRow3Page1 = ['*', '"', "'", ':', ';', '!', '?', '%', '=', '#'];

  static const List<String> symRow2Page2 = ['~', '`', '|', '•', '√', 'π', '÷', '×', '§', 'Δ'];
  static const List<String> symRow3Page2 = ['£', '€', '¥', '¢', '^', '°', '[', ']', '{', '}'];

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(keyboardProvider.notifier);

    final row2 = _isPage2 ? symRow2Page2 : symRow2Page1;
    final row3 = _isPage2 ? symRow3Page2 : symRow3Page1;

    return Column(
      children: [
        // Numbers
        Row(
          children: numRow1.map((char) {
            return KeyButton(
              label: char,
              onTap: () => notifier.handleKeyTap(char),
            );
          }).toList(),
        ),

        // Row 2 Symbols
        Row(
          children: row2.map((char) {
            return KeyButton(
              label: char,
              onTap: () => notifier.handleKeyTap(char),
            );
          }).toList(),
        ),

        // Row 3 Symbols (Toggle Page 1/2, Symbols, Delete)
        Row(
          children: [
            KeyButton(
              label: _isPage2 ? '1/2' : '2/2',
              flex: 1.5,
              isSpecial: true,
              onTap: () => setState(() => _isPage2 = !_isPage2),
            ),
            ...row3.map((char) {
              return KeyButton(
                label: char,
                onTap: () => notifier.handleKeyTap(char),
              );
            }),
            KeyButton(
              label: '⌫',
              flex: 1.5,
              isSpecial: true,
              icon: const Icon(Icons.backspace_outlined, size: 20),
              onTap: () => notifier.handleDelete(),
            ),
          ],
        ),

        // Row 4 (ABC, Space, Arrow keys, Enter)
        Row(
          children: [
            KeyButton(
              label: 'ABC',
              flex: 1.5,
              isSpecial: true,
              onTap: () => notifier.setLayoutMode(KeyboardLayoutMode.english),
            ),
            KeyButton(
              label: 'Space',
              flex: 3.5,
              onTap: () => notifier.handleSpace(),
            ),
            KeyButton(
              label: '←',
              flex: 1.0,
              onTap: () => notifier.handleKeyTap('←'),
            ),
            KeyButton(
              label: '→',
              flex: 1.0,
              onTap: () => notifier.handleKeyTap('→'),
            ),
            KeyButton(
              label: '↵',
              flex: 1.5,
              isSpecial: true,
              icon: const Icon(Icons.keyboard_return, size: 20),
              onTap: () => notifier.handleReturn(),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../key_button.dart';
import '../../../../providers/keyboard_provider.dart';

class EnglishLayout extends ConsumerWidget {
  const EnglishLayout({super.key});

  static const List<String> row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  static const List<String> row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  static const List<String> row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

  static const Map<String, List<String>> popupMap = {
    'a': ['á', 'à', 'â', 'ä', 'å', 'æ', '@'],
    'e': ['é', 'è', 'ê', 'ë', '3'],
    'i': ['í', 'ì', 'î', 'ï', '1'],
    'o': ['ó', 'ò', 'ô', 'ö', '0'],
    'u': ['ú', 'ù', 'û', 'ü'],
    's': ['ß', '$'],
    'c': ['ç'],
    'n': ['ñ'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(keyboardProvider);
    final notifier = ref.read(keyboardProvider.notifier);

    return Column(
      children: [
        // Row 1
        Row(
          children: row1.map((char) {
            final displayChar = state.shiftState != ShiftState.off ? char.toUpperCase() : char;
            return KeyButton(
              label: displayChar,
              popupKeys: popupMap[char],
              onTap: () => notifier.handleKeyTap(displayChar),
            );
          }).toList(),
        ),

        // Row 2
        Row(
          children: [
            const Spacer(flex: 5),
            ...row2.map((char) {
              final displayChar = state.shiftState != ShiftState.off ? char.toUpperCase() : char;
              return KeyButton(
                label: displayChar,
                popupKeys: popupMap[char],
                onTap: () => notifier.handleKeyTap(displayChar),
              );
            }),
            const Spacer(flex: 5),
          ],
        ),

        // Row 3 (Shift, Z-M, Delete)
        Row(
          children: [
            KeyButton(
              label: '⇧',
              flex: 1.5,
              isSpecial: true,
              icon: Icon(
                state.shiftState == ShiftState.capsLock
                    ? Icons.keyboard_capslock
                    : Icons.arrow_upward,
                color: state.shiftState != ShiftState.off ? Colors.lightBlueAccent : null,
              ),
              onTap: () => notifier.toggleShift(),
            ),
            ...row3.map((char) {
              final displayChar = state.shiftState != ShiftState.off ? char.toUpperCase() : char;
              return KeyButton(
                label: displayChar,
                popupKeys: popupMap[char],
                onTap: () => notifier.handleKeyTap(displayChar),
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

        // Row 4 (123, Symbol, Spacebar, Return)
        Row(
          children: [
            KeyButton(
              label: '?123',
              flex: 1.5,
              isSpecial: true,
              onTap: () => notifier.setLayoutMode(KeyboardLayoutMode.numeric),
            ),
            KeyButton(
              label: ',',
              flex: 1.0,
              onTap: () => notifier.handleKeyTap(','),
            ),
            KeyButton(
              label: 'Space',
              flex: 4.5,
              onTap: () => notifier.handleSpace(),
            ),
            KeyButton(
              label: '.',
              flex: 1.0,
              onTap: () => notifier.handleKeyTap('.'),
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

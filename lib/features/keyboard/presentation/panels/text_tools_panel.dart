import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/text_tools_service.dart';
import '../../../../core/services/native_input_service.dart';

class TextToolsPanel extends ConsumerStatefulWidget {
  const TextToolsPanel({super.key});

  @override
  ConsumerState<TextToolsPanel> createState() => _TextToolsPanelState();
}

class _TextToolsPanelState extends ConsumerState<TextToolsPanel> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).activeTheme;
    final styles = TextToolsService.generateAllStyles(_inputText);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: TextField(
              onChanged: (val) => setState(() => _inputText = val),
              style: TextStyle(color: theme.keyTextColor, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Type text here to convert into stylish fonts...',
                hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
                prefixIcon: Icon(Icons.style, size: 16, color: theme.accentColor),
                filled: true,
                fillColor: theme.keyColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: styles.entries.map((entry) {
                return InkWell(
                  onTap: () => NativeInputService.commitText(entry.value),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.keyColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainState.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(color: theme.accentColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: theme.keyTextColor, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

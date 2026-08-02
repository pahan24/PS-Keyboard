import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../providers/secret_encoder_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/native_input_service.dart';

class SecretEncoderPanel extends ConsumerWidget {
  const SecretEncoderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).activeTheme;
    final state = ref.watch(secretEncoderProvider);
    final notifier = ref.read(secretEncoderProvider.notifier);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.accentColor, width: 1.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header & Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: theme.accentColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Secret AES-256 Encoder',
                    style: TextStyle(
                      color: theme.keyTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Encode', style: TextStyle(fontSize: 11))),
                  ButtonSegment(value: true, label: Text('Decode', style: TextStyle(fontSize: 11))),
                ],
                selected: {state.isDecodeMode},
                onSelectionChanged: (set) => notifier.toggleMode(set.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Input Text / Cipher Field
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: state.isDecodeMode ? state.cipherToDecode : state.inputText,
                    )..selection = TextSelection.collapsed(
                        offset: (state.isDecodeMode ? state.cipherToDecode : state.inputText).length,
                      ),
                    onChanged: (val) {
                      if (state.isDecodeMode) {
                        notifier.setCipherToDecode(val);
                      } else {
                        notifier.setInputText(val);
                      }
                    },
                    maxLines: 3,
                    style: TextStyle(color: theme.keyTextColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: state.isDecodeMode
                          ? 'Paste PSK-v1: encoded secret payload here...'
                          : 'Enter private message to encrypt...',
                      hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
                      filled: true,
                      fillColor: theme.keyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.borderColor),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Passkey Field
                SizedBox(
                  width: 90,
                  child: TextField(
                    obscureText: true,
                    onChanged: (val) => notifier.setPasskey(val),
                    style: TextStyle(color: theme.keyTextColor, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Passkey',
                      hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
                      filled: true,
                      fillColor: theme.keyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.borderColor),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Output / Action Buttons
          if (!state.isDecodeMode) ...[
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => notifier.encode(),
                  icon: const Icon(Icons.lock, size: 16),
                  label: const Text('ENCODE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentColor,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                if (state.encodedResult.isNotEmpty) ...[
                  IconButton(
                    icon: Icon(Icons.copy, color: theme.accentColor),
                    tooltip: 'Copy Encrypted Text',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: state.encodedResult));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Encrypted secret copied to clipboard!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: theme.accentColor),
                    tooltip: 'Share Secret',
                    onPressed: () {
                      Share.share(state.encodedResult, subject: 'PS Keyboard Secret');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: theme.accentColor),
                    tooltip: 'Insert into active input',
                    onPressed: () {
                      NativeInputService.commitText(state.encodedResult);
                    },
                  ),
                ],
              ],
            ),
            if (state.encodedResult.isNotEmpty)
              Text(
                'Result: ${state.encodedResult}',
                style: TextStyle(color: theme.accentColor, fontSize: 11, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
          ] else ...[
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => notifier.decode(),
                  icon: const Icon(Icons.key, size: 16),
                  label: const Text('DECODE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentColor,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
            if (state.decodedResult.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  'Decrypted: ${state.decodedResult}',
                  style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

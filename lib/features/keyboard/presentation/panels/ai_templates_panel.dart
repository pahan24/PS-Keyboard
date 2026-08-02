import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/native_input_service.dart';

class AiTemplatesPanel extends ConsumerWidget {
  const AiTemplatesPanel({super.key});

  static const Map<String, List<String>> templates = {
    '⚡ Quick Replies': [
      'I will call you back shortly.',
      'Thanks for reaching out! 👍',
      'Sounds good to me.',
      'Let me check and get back to you.',
      'මම පස්සේ කතා කරන්නම්.',
    ],
    '✉️ Email Intro': [
      'Dear Sir/Madam,\n\nI hope this email finds you well.',
      'Hi Team,\n\nPlease find the requested details attached.',
      'Best regards,\nPS Keyboard User',
    ],
    '#️⃣ Hashtags': [
      '#PSKeyboard #Flutter #SinhalaKeyboard #CyberpunkUI #Tech2026',
      '#Coding #Developer #Android #Material3 #Riverpod',
    ],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).activeTheme;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: ListView(
        children: templates.entries.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  category.key,
                  style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: category.value.map((phrase) {
                  return InkWell(
                    onTap: () => NativeInputService.commitText(phrase),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.keyColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.borderColor),
                      ),
                      child: Text(
                        phrase,
                        style: TextStyle(color: theme.keyTextColor, fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}

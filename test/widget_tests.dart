import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ps_keyboard/features/keyboard/presentation/key_button.dart';
import 'package:ps_keyboard/features/keyboard/presentation/panels/secret_encoder_panel.dart';

void main() {
  testWidgets('KeyButton renders label and triggers tap callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                KeyButton(
                  label: 'A',
                  onTap: () {
                    tapped = true;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    await tester.tap(find.text('A'));
    expect(tapped, isTrue);
  });

  testWidgets('SecretEncoderPanel renders title and Encode button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SecretEncoderPanel(),
          ),
        ),
      ),
    );

    expect(find.text('Secret AES-256 Encoder'), findsOneWidget);
    expect(find.text('ENCODE'), findsOneWidget);
  });
}

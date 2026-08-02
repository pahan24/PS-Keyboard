import 'package:flutter_test/flutter_test.dart';
import 'package:ps_keyboard/core/services/encryption_service.dart';
import 'package:ps_keyboard/core/services/sinhala_converter_service.dart';
import 'package:ps_keyboard/core/services/text_tools_service.dart';
import 'package:ps_keyboard/core/theme/keyboard_theme.dart';

void main() {
  group('Secret Encryption Service Unit Tests', () {
    test('Encryption generates valid PSK-v1 prefix and decrypts back to original payload', () {
      const secret = 'Top Secret Cyber PS Keyboard Message 2026';
      const key = 'MySecretPasskey123';

      final encrypted = EncryptionService.encryptText(secret, passkey: key);
      expect(encrypted.startsWith('PSK-v1:'), isTrue);

      final decrypted = EncryptionService.decryptText(encrypted, passkey: key);
      expect(decrypted, equals(secret));
    });

    test('Encrypted format detection identifies PSK tags', () {
      expect(EncryptionService.isEncryptedFormat('PSK-v1:aW52YWxpZA=='), isTrue);
      expect(EncryptionService.isEncryptedFormat('Normal plain text'), isFalse);
    });
  });

  group('Sinhala Phonetic & Wijesekera Typing Converter Tests', () {
    test('Converts phonetic Singlish input to Sinhala Unicode accurately', () {
      final text1 = SinhalaConverterService.convertPhonetic('mama');
      expect(text1, equals('මම'));

      final text2 = SinhalaConverterService.convertPhonetic('subha');
      expect(text2, equals('සුභ'));
    });
  });

  group('Text Tools & Stylish Fonts Tests', () {
    test('Transforms plain text into stylish circles, fullwidth, and uppercase', () {
      final circles = TextToolsService.toCircles('ABC');
      expect(circles, equals('ⒶⒷⒸ'));

      final fullwidth = TextToolsService.toFullwidth('ABC');
      expect(fullwidth, equals('ＡＢＣ'));

      final upper = TextToolsService.toUppercase('hello');
      expect(upper, equals('HELLO'));
    });
  });

  group('Theme JSON Serialization Tests', () {
    test('Serializes and deserializes KeyboardThemeData accurately', () {
      final theme = KeyboardThemeData.cyberpunk;
      final json = theme.toJson();
      final restored = KeyboardThemeData.fromJson(json);

      expect(restored.id, equals(theme.id));
      expect(restored.name, equals(theme.name));
      expect(restored.isRgbAnimated, equals(theme.isRgbAnimated));
      expect(restored.liveBackground, equals(theme.liveBackground));
    });
  });
}

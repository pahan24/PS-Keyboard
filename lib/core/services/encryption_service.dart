import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../constants/app_constants.dart';

class EncryptionService {
  /// Derive a 32-byte (256-bit) Key from passkey using SHA-256
  static encrypt.Key _deriveKey(String passkey) {
    final bytes = utf8.encode(passkey);
    final digest = sha256.convert(bytes);
    return encrypt.Key(Uint8List.fromList(digest.bytes));
  }

  /// Derive a 16-byte (128-bit) IV from passkey using MD5
  static encrypt.IV _deriveIV(String passkey) {
    final bytes = utf8.encode(passkey);
    final digest = md5.convert(bytes);
    return encrypt.IV(Uint8List.fromList(digest.bytes));
  }

  /// Encrypt plain text using AES-256 CBC with Base64 & PSK-v1 prefix
  static String encryptText(String plainText, {String? passkey}) {
    if (plainText.isEmpty) return '';
    final keyStr = (passkey != null && passkey.isNotEmpty) 
        ? passkey 
        : AppConstants.defaultPasskey;

    final key = _deriveKey(keyStr);
    final iv = _deriveIV(keyStr);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${AppConstants.pskPrefix}${encrypted.base64}';
  }

  /// Decrypt PSK-v1 formatted text back to plain text
  static String decryptText(String cipherText, {String? passkey}) {
    if (cipherText.isEmpty) return '';
    
    var rawPayload = cipherText.trim();
    if (rawPayload.startsWith(AppConstants.pskPrefix)) {
      rawPayload = rawPayload.substring(AppConstants.pskPrefix.length);
    }

    final keyStr = (passkey != null && passkey.isNotEmpty) 
        ? passkey 
        : AppConstants.defaultPasskey;

    final key = _deriveKey(keyStr);
    final iv = _deriveIV(keyStr);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    try {
      final decrypted = encrypter.decrypt64(rawPayload, iv: iv);
      return decrypted;
    } catch (e) {
      return 'Error: Invalid key or corrupted secret message.';
    }
  }

  /// Check if text is PSK-v1 formatted secret
  static bool isEncryptedFormat(String text) {
    return text.trim().startsWith(AppConstants.pskPrefix);
  }
}

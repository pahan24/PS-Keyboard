import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/encryption_service.dart';

class SecretEncoderState {
  final String inputText;
  final String passkey;
  final String encodedResult;
  final String cipherToDecode;
  final String decodedResult;
  final bool isDecodeMode;

  const SecretEncoderState({
    this.inputText = '',
    this.passkey = '',
    this.encodedResult = '',
    this.cipherToDecode = '',
    this.decodedResult = '',
    this.isDecodeMode = false,
  });

  SecretEncoderState copyWith({
    String? inputText,
    String? passkey,
    String? encodedResult,
    String? cipherToDecode,
    String? decodedResult,
    bool? isDecodeMode,
  }) {
    return SecretEncoderState(
      inputText: inputText ?? this.inputText,
      passkey: passkey ?? this.passkey,
      encodedResult: encodedResult ?? this.encodedResult,
      cipherToDecode: cipherToDecode ?? this.cipherToDecode,
      decodedResult: decodedResult ?? this.decodedResult,
      isDecodeMode: isDecodeMode ?? this.isDecodeMode,
    );
  }
}

class SecretEncoderNotifier extends StateNotifier<SecretEncoderState> {
  SecretEncoderNotifier() : super(const SecretEncoderState());

  void setInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  void setPasskey(String key) {
    state = state.copyWith(passkey: key);
  }

  void setCipherToDecode(String cipher) {
    state = state.copyWith(cipherToDecode: cipher);
  }

  void toggleMode(bool isDecodeMode) {
    state = state.copyWith(isDecodeMode: isDecodeMode);
  }

  void encode() {
    if (state.inputText.isEmpty) return;
    final encoded = EncryptionService.encryptText(
      state.inputText,
      passkey: state.passkey,
    );
    state = state.copyWith(encodedResult: encoded);
  }

  void decode() {
    if (state.cipherToDecode.isEmpty) return;
    final decoded = EncryptionService.decryptText(
      state.cipherToDecode,
      passkey: state.passkey,
    );
    state = state.copyWith(decodedResult: decoded);
  }

  void loadDetectedPsk(String pskText) {
    state = state.copyWith(
      cipherToDecode: pskText,
      isDecodeMode: true,
    );
    decode();
  }
}

final secretEncoderProvider = StateNotifierProvider<SecretEncoderNotifier, SecretEncoderState>((ref) {
  return SecretEncoderNotifier();
});

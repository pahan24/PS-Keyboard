import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class NativeInputService {
  static const MethodChannel _channel = MethodChannel(AppConstants.channelName);
  static const MethodChannel _settingsChannel = MethodChannel(AppConstants.settingsChannel);

  static Future<void> commitText(String text) async {
    try {
      await _channel.invokeMethod('commitText', {'text': text});
    } on PlatformException catch (_) {
      // Fallback for desktop testing / non-android env
    }
  }

  static Future<void> deleteSurroundingText({int before = 1, int after = 0}) async {
    try {
      await _channel.invokeMethod('deleteSurroundingText', {
        'before': before,
        'after': after,
      });
    } on PlatformException catch (_) {}
  }

  static Future<void> sendKeyEvent(int keyCode) async {
    try {
      await _channel.invokeMethod('sendKeyEvent', {'keyCode': keyCode});
    } on PlatformException catch (_) {}
  }

  static Future<void> performEditorAction(int action) async {
    try {
      await _channel.invokeMethod('performEditorAction', {'action': action});
    } on PlatformException catch (_) {}
  }

  static Future<void> playSound(int soundType) async {
    try {
      await _channel.invokeMethod('playSound', {'soundType': soundType});
    } on PlatformException catch (_) {}
  }

  static Future<void> vibrate(int duration) async {
    try {
      await _channel.invokeMethod('vibrate', {'duration': duration});
    } on PlatformException catch (_) {}
  }

  static Future<void> showInputMethodPicker() async {
    try {
      await _channel.invokeMethod('showInputMethodPicker');
    } on PlatformException catch (_) {
      try {
        await _settingsChannel.invokeMethod('openInputMethodSettings');
      } catch (_) {}
    }
  }

  static Future<String> getClipboardText() async {
    try {
      final String? text = await _channel.invokeMethod('getClipboardText');
      return text ?? '';
    } on PlatformException catch (_) {
      return '';
    }
  }
}

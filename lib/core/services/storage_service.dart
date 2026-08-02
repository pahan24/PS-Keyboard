import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../theme/keyboard_theme.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box _clipboardBox;
  static late Box _customThemesBox;

  static Future<void> init({bool isTest = false}) async {
    if (!isTest) {
      await Hive.initFlutter();
    } else {
      Hive.init('.');
    }
    _prefs = await SharedPreferences.getInstance();
    _clipboardBox = await Hive.openBox(AppConstants.clipboardBox);
    _customThemesBox = await Hive.openBox(AppConstants.customThemesBox);
  }

  // Active Theme
  static KeyboardThemeData getActiveTheme() {
    try {
      final raw = _prefs.getString(AppConstants.themeStorageKey);
      if (raw == null) return KeyboardThemeData.cyberpunk;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return KeyboardThemeData.fromJson(map);
    } catch (_) {
      return KeyboardThemeData.cyberpunk;
    }
  }

  static Future<void> saveActiveTheme(KeyboardThemeData theme) async {
    try {
      final raw = jsonEncode(theme.toJson());
      await _prefs.setString(AppConstants.themeStorageKey, raw);
    } catch (_) {}
  }

  // Custom User Themes
  static List<KeyboardThemeData> getCustomThemes() {
    final List<KeyboardThemeData> list = [];
    try {
      for (var i = 0; i < _customThemesBox.length; i++) {
        final raw = _customThemesBox.getAt(i);
        if (raw != null) {
          try {
            final map = jsonDecode(raw.toString()) as Map<String, dynamic>;
            list.add(KeyboardThemeData.fromJson(map));
          } catch (_) {}
        }
      }
    } catch (_) {}
    return list;
  }

  static Future<void> saveCustomTheme(KeyboardThemeData theme) async {
    try {
      final raw = jsonEncode(theme.toJson());
      await _customThemesBox.put(theme.id, raw);
    } catch (_) {}
  }

  // Clipboard History
  static List<Map<String, dynamic>> getClipboardClips() {
    final List<Map<String, dynamic>> clips = [];
    try {
      for (var i = 0; i < _clipboardBox.length; i++) {
        final item = _clipboardBox.getAt(i);
        if (item is Map) {
          clips.add(Map<String, dynamic>.from(item));
        }
      }
    } catch (_) {}
    return clips.reversed.toList();
  }

  static Future<void> addClipboardClip(String text, {bool isPinned = false}) async {
    if (text.trim().isEmpty) return;
    try {
      final existingIndex = _clipboardBox.values.toList().indexWhere(
        (element) => element is Map && element['text'] == text,
      );

      final clip = {
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isPinned': isPinned,
      };

      if (existingIndex != -1) {
        await _clipboardBox.putAt(existingIndex, clip);
      } else {
        await _clipboardBox.add(clip);
      }
    } catch (_) {}
  }

  static Future<void> deleteClipboardClip(int index) async {
    try {
      await _clipboardBox.deleteAt(_clipboardBox.length - 1 - index);
    } catch (_) {}
  }

  static Future<void> clearClipboardHistory() async {
    try {
      await _clipboardBox.clear();
    } catch (_) {}
  }

  // Settings Key-Values
  static double getKeyboardHeightFactor() {
    try {
      return _prefs.getDouble('keyboard_height') ?? 1.0;
    } catch (_) {
      return 1.0;
    }
  }

  static Future<void> setKeyboardHeightFactor(double value) async {
    try {
      await _prefs.setDouble('keyboard_height', value);
    } catch (_) {}
  }

  static int getSoundType() {
    try {
      return _prefs.getInt('sound_type') ?? 1;
    } catch (_) {
      return 1;
    }
  }

  static Future<void> setSoundType(int type) async {
    try {
      await _prefs.setInt('sound_type', type);
    } catch (_) {}
  }

  static int getHapticStrength() {
    try {
      return _prefs.getInt('haptic_strength') ?? 20;
    } catch (_) {
      return 20;
    }
  }

  static Future<void> setHapticStrength(int ms) async {
    try {
      await _prefs.setInt('haptic_strength', ms);
    } catch (_) {}
  }

  static bool getAutoCapitalization() {
    try {
      return _prefs.getBool('auto_capitalization') ?? true;
    } catch (_) {
      return true;
    }
  }

  static Future<void> setAutoCapitalization(bool val) async {
    try {
      await _prefs.setBool('auto_capitalization', val);
    } catch (_) {}
  }
}

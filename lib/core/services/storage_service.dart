import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../theme/keyboard_theme.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box _clipboardBox;
  static late Box _customThemesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _prefs = await SharedPreferences.getInstance();
    _clipboardBox = await Hive.openBox(AppConstants.clipboardBox);
    _customThemesBox = await Hive.openBox(AppConstants.customThemesBox);
  }

  // Active Theme
  static KeyboardThemeData getActiveTheme() {
    final raw = _prefs.getString(AppConstants.themeStorageKey);
    if (raw == null) return KeyboardThemeData.cyberpunk;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return KeyboardThemeData.fromJson(map);
    } catch (_) {
      return KeyboardThemeData.cyberpunk;
    }
  }

  static Future<void> saveActiveTheme(KeyboardThemeData theme) async {
    final raw = jsonEncode(theme.toJson());
    await _prefs.setString(AppConstants.themeStorageKey, raw);
  }

  // Custom User Themes
  static List<KeyboardThemeData> getCustomThemes() {
    final List<KeyboardThemeData> list = [];
    for (var i = 0; i < _customThemesBox.length; i++) {
      final raw = _customThemesBox.getAt(i);
      if (raw != null) {
        try {
          final map = jsonDecode(raw.toString()) as Map<String, dynamic>;
          list.add(KeyboardThemeData.fromJson(map));
        } catch (_) {}
      }
    }
    return list;
  }

  static Future<void> saveCustomTheme(KeyboardThemeData theme) async {
    final raw = jsonEncode(theme.toJson());
    await _customThemesBox.put(theme.id, raw);
  }

  // Clipboard History
  static List<Map<String, dynamic>> getClipboardClips() {
    final List<Map<String, dynamic>> clips = [];
    for (var i = 0; i < _clipboardBox.length; i++) {
      final item = _clipboardBox.getAt(i);
      if (item is Map) {
        clips.add(Map<String, dynamic>.from(item));
      }
    }
    return clips.reversed.toList();
  }

  static Future<void> addClipboardClip(String text, {bool isPinned = false}) async {
    if (text.trim().isEmpty) return;
    // Check duplicate
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
  }

  static Future<void> deleteClipboardClip(int index) async {
    await _clipboardBox.deleteAt(_clipboardBox.length - 1 - index);
  }

  static Future<void> clearClipboardHistory() async {
    await _clipboardBox.clear();
  }

  // Settings Key-Values
  static double getKeyboardHeightFactor() {
    return _prefs.getDouble('keyboard_height') ?? 1.0;
  }

  static Future<void> setKeyboardHeightFactor(double value) async {
    await _prefs.setDouble('keyboard_height', value);
  }

  static int getSoundType() {
    return _prefs.getInt('sound_type') ?? 1; // 1: Mechanical, 2: Typewriter, 3: Soft Click
  }

  static Future<void> setSoundType(int type) async {
    await _prefs.setInt('sound_type', type);
  }

  static int getHapticStrength() {
    return _prefs.getInt('haptic_strength') ?? 20; // 0-100 ms
  }

  static Future<void> setHapticStrength(int ms) async {
    await _prefs.setInt('haptic_strength', ms);
  }

  static bool getAutoCapitalization() {
    return _prefs.getBool('auto_capitalization') ?? true;
  }

  static Future<void> setAutoCapitalization(bool val) async {
    await _prefs.setBool('auto_capitalization', val);
  }
}

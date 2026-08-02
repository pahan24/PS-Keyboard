class AppConstants {
  static const String appName = 'PS Keyboard';
  static const String packageName = 'com.ps.keyboard';
  static const String channelName = 'com.ps.keyboard/input';
  static const String settingsChannel = 'com.ps.keyboard/settings';

  // Secret Encoder version tag
  static const String pskPrefix = 'PSK-v1:';

  // Default Passkey
  static const String defaultPasskey = 'PS-KEYBOARD-SECRET-2026';

  // Storage Keys
  static const String themeStorageKey = 'ps_active_theme';
  static const String settingsStorageKey = 'ps_user_settings';
  static const String clipboardBox = 'ps_clipboard_history';
  static const String dictionaryBox = 'ps_user_dictionary';
  static const String customThemesBox = 'ps_custom_themes';

  // Sound Types
  static const int soundStandard = 5;
  static const int soundDelete = 7;
  static const int soundReturn = 8;
  static const int soundSpacebar = 6;
}

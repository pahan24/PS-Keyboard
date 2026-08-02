import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/main_app/home_settings_screen.dart';
import 'features/keyboard/presentation/keyboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(
    const ProviderScope(
      child: PSKeyboardApp(),
    ),
  );
}

class PSKeyboardApp extends StatelessWidget {
  final bool isKeyboardService;

  const PSKeyboardApp({super.key, this.isKeyboardService = false});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'PS Keyboard',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: isKeyboardService
              ? const Scaffold(body: KeyboardView())
              : const HomeSettingsScreen(),
        );
      },
    );
  }
}

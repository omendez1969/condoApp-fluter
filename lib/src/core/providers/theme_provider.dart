import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';

  ThemeProvider(this.prefs) {
    // Cargar el tema guardado o usar el del sistema por defecto
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isSystemTheme => _themeMode == ThemeMode.system;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;

    _themeMode = mode;
    prefs.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  void toggleTheme() {
    final isDark = _themeMode == ThemeMode.dark;
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void useSystemTheme() {
    setThemeMode(ThemeMode.system);
  }
} 
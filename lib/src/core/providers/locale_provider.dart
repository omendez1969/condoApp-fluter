import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selectedLocale';
  Locale _locale = const Locale('es');
  final SharedPreferences _prefs;

  LocaleProvider(this._prefs) {
    // Cargar el idioma guardado
    final String? savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({Key? key}) : super(key: key);

  void _showRestartSnackBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.restart_alt,  // Icono de reinicio
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.restartRequired,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.restartMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          _buildSectionTitle(context, l10n.theme),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.lightMode),
                  secondary: const Icon(Icons.light_mode),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.darkMode),
                  secondary: const Icon(Icons.dark_mode),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.systemTheme),
                  secondary: const Icon(Icons.settings_system_daydream),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(context, l10n.language),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l10n.spanish),
                  secondary: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                  value: 'es',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(Locale(value));
                      _showRestartSnackBar(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(l10n.english),
                  secondary: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                  value: 'en',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(Locale(value));
                      _showRestartSnackBar(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

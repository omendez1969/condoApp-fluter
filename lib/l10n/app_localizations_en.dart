// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get systemTheme => 'System theme';

  @override
  String get restartRequired => 'Restart required';

  @override
  String get restartMessage =>
      'Please restart the application to apply the language change';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutConfirmTitle => 'Sign out?';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String signInWith(String provider) {
    return 'Sign in with $provider';
  }

  @override
  String get loginTitle => 'Login';

  @override
  String get loginButton => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get welcome => 'Welcome!';

  @override
  String get userNotFound => 'No account exists with this email';

  @override
  String get wrongPassword => 'Incorrect password';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later';

  @override
  String get unexpectedError => 'Unexpected error';
}

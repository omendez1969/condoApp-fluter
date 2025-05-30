// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemTheme => 'Tema del sistema';

  @override
  String get restartRequired => 'Reinicio requerido';

  @override
  String get restartMessage =>
      'Por favor, reinicia la aplicación para aplicar el cambio de idioma';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get logoutConfirmMessage =>
      '¿Estás seguro que deseas cerrar la sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get comingSoon => 'Disponible próximamente';

  @override
  String signInWith(String provider) {
    return 'Iniciar sesión con $provider';
  }

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get emailRequired => 'El correo es requerido';

  @override
  String get invalidEmailFormat => 'Formato de correo inválido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get welcome => '¡Bienvenido!';

  @override
  String get userNotFound => 'No existe una cuenta con este correo';

  @override
  String get wrongPassword => 'Contraseña incorrecta';

  @override
  String get invalidEmail => 'Correo electrónico inválido';

  @override
  String get tooManyRequests => 'Demasiados intentos. Intenta más tarde';

  @override
  String get unexpectedError => 'Error inesperado';
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/constants/social_icons.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: "1@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "12345678");

  bool _obscureText = true;
  bool _loading = false;

  String? _emailError;
  String? _passwordError;

  // Valida el formato del email usando RegExp
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _loginWithEmailPassword() async {
    final l10n = AppLocalizations.of(context)!;
    
    setState(() {
      _loading = true;
      _emailError = null;
      _passwordError = null;
    });

    // Validación visual por campo
    bool hasError = false;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _emailError = l10n.emailRequired);
      hasError = true;
    } else if (!_isValidEmail(email)) {
      setState(() => _emailError = l10n.invalidEmailFormat);
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = l10n.passwordRequired);
      hasError = true;
    }

    if (hasError) {
      setState(() => _loading = false);
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );
      // Login exitoso
      _showSnackBar(l10n.welcome, color: Colors.green, icon: Icons.check_circle);

      // Navegar a HomeScreen reemplazando el login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      String message = '';
      IconData icon = Icons.error;

      switch (e.code) {
        case 'user-not-found':
          message = l10n.userNotFound;
          icon = Icons.person_off;
          setState(() => _emailError = l10n.userNotFound);
          break;
        case 'wrong-password':
          message = l10n.wrongPassword;
          icon = Icons.lock_open;
          setState(() => _passwordError = l10n.wrongPassword);
          break;
        case 'invalid-email':
          message = l10n.invalidEmail;
          icon = Icons.alternate_email;
          setState(() => _emailError = l10n.invalidEmail);
          break;
        case 'too-many-requests':
          message = l10n.tooManyRequests;
          icon = Icons.hourglass_empty;
          break;
        default:
          message = l10n.unexpectedError;
          icon = Icons.error_outline;
      }

      _showSnackBar(message, color: Colors.red, icon: icon);
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showSnackBar(l10n.unexpectedError, color: Colors.red, icon: Icons.error);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, {Color color = Colors.red, IconData icon = Icons.error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
      ),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required String provider,
    Color? iconColor,
    String? lightLogo,
    String? darkLogo,
    bool isSvg = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: lightLogo != null && darkLogo != null
              ? Opacity(
                  opacity: 0.5,
                  child: isSvg
                      ? SvgPicture.asset(
                          isDark ? darkLogo : lightLogo,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          isDark ? darkLogo : lightLogo,
                          width: 24,
                          height: 24,
                        ),
                )
              : Icon(
                  icon,
                  size: 28,
                  color: iconColor?.withOpacity(0.5) ?? colorScheme.outline.withOpacity(0.5),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.signInWith(provider),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.outline.withOpacity(0.7),
          ),
        ),
        Text(
          l10n.comingSoon,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.primary.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginTitle),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: colorScheme.primary),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                  errorText: _emailError,
                ),
                onChanged: (value) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToForgotPassword,
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _loading ? null : _loginWithEmailPassword,
                icon: _loading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(l10n.loginButton),
              ),
              TextButton(
                onPressed: _goToRegister,
                child: Text(l10n.createAccount),
              ),
              const SizedBox(height: 32),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialLoginButton(
                      icon: Icons.g_mobiledata_rounded,
                      provider: "Google",
                      iconColor: Colors.red,
                      lightLogo: SocialIcons.googleLight,
                      darkLogo: SocialIcons.googleDark,
                      isSvg: true,
                    ),
                    _buildSocialLoginButton(
                      icon: Icons.apple_rounded,
                      provider: "Apple",
                      lightLogo: SocialIcons.appleLight,
                      darkLogo: SocialIcons.appleDark,
                      isSvg: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

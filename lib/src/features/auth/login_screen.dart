import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    setState(() {
      _loading = true;
      _emailError = null;
      _passwordError = null;
    });

    // Validación visual por campo
    bool hasError = false;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _emailError = "El correo es requerido");
      hasError = true;
    } else if (!_isValidEmail(email)) {
      setState(() => _emailError = "Formato de correo inválido");
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = "La contraseña es requerida");
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
      _showSnackBar('¡Bienvenido!', color: Colors.green, icon: Icons.check_circle);

      // Navegar a HomeScreen reemplazando el login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      IconData icon = Icons.error;

      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no registrado.';
          icon = Icons.person_off;
          setState(() => _emailError = "No existe una cuenta con este correo");
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta.';
          icon = Icons.lock_open;
          setState(() => _passwordError = "Contraseña incorrecta");
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido.';
          icon = Icons.alternate_email;
          setState(() => _emailError = "Correo electrónico inválido");
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos. Intenta más tarde.';
          icon = Icons.hourglass_empty;
          break;
        default:
          message = 'Error: ${e.message ?? "Desconocido"}';
          icon = Icons.error_outline;
      }

      _showSnackBar(message, color: Colors.red, icon: icon);
    } catch (e) {
      _showSnackBar('Error inesperado', color: Colors.red, icon: Icons.error);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
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
                  labelText: 'Contraseña',
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
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToForgotPassword,
                  child: const Text("¿Olvidaste tu contraseña?"),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _loginWithEmailPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _goToRegister,
                child: const Text("Crear cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

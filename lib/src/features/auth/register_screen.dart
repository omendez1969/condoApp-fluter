import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _loading = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Agrega esta función para validar formato de email:
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _registerUser() async {
    setState(() {
      _loading = true;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool hasError = false;

    if (email.isEmpty) {
      setState(() => _emailError = "El correo es requerido");
      hasError = true;
    } else if (!_isValidEmail(email)) {
      setState(() => _emailError = "Formato de correo inválido");
      hasError = true;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = "La contraseña es requerida");
      hasError = true;
    }
    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = "Confirma la contraseña");
      hasError = true;
    }
    if (!hasError && password != confirmPassword) {
      setState(() => _confirmPasswordError = "Las contraseñas no coinciden");
      hasError = true;
    }

    if (hasError) {
      setState(() => _loading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _showSnackBar("¡Registro exitoso! Ahora puedes iniciar sesión.", color: Colors.green, icon: Icons.check_circle);

      // Regresa al login después de registrar
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = '';
      IconData icon = Icons.error;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'El correo ya está registrado.';
          icon = Icons.alternate_email;
          setState(() => _emailError = "El correo ya está registrado");
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido.';
          icon = Icons.alternate_email;
          setState(() => _emailError = "Correo electrónico inválido");
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil.';
          icon = Icons.lock_open;
          setState(() => _passwordError = "La contraseña es muy débil");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, size: 64, color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: _confirmPasswordError,
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
                  if (_confirmPasswordError != null) {
                    setState(() => _confirmPasswordError = null);
                  }
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Registrar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

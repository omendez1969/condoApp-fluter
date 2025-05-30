import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _emailError;

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _loading = true;
      _emailError = null;
    });

    final email = _emailController.text.trim();

    // Validación visual del campo
    if (email.isEmpty) {
      setState(() {
        _emailError = "El correo es requerido";
        _loading = false;
      });
      return;
    } else if (!_isValidEmail(email)) {
      setState(() {
        _emailError = "Formato de correo inválido";
        _loading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar(
        "Se ha enviado el enlace para restablecer la contraseña a tu correo.",
        color: Colors.green,
        icon: Icons.check_circle,
      );
      // Puedes navegar atrás si quieres, después de un breve tiempo:
      // Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      String message = '';
      IconData icon = Icons.error;

      switch (e.code) {
        case 'user-not-found':
          message = "No existe una cuenta con este correo.";
          setState(() => _emailError = "No existe una cuenta con este correo.");
          break;
        case 'invalid-email':
          message = "Correo electrónico inválido.";
          setState(() => _emailError = "Correo electrónico inválido");
          break;
        default:
          message = "Error: ${e.message ?? "Desconocido"}";
      }
      _showSnackBar(message, color: Colors.red, icon: icon);
    } catch (e) {
      _showSnackBar("Error inesperado", color: Colors.red, icon: Icons.error);
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
        title: const Text('Recuperar contraseña'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_reset, size: 64, color: Theme.of(context).colorScheme.primary),
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
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendPasswordResetEmail,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Enviar enlace', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

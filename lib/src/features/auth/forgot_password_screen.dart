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

  Future<void> _resetPassword() async {
    setState(() => _loading = true);

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("Por favor ingresa tu correo electrónico", color: Colors.orange, icon: Icons.info);
      setState(() => _loading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar(
        "Se envió un correo para restablecer la contraseña.",
        color: Colors.green,
        icon: Icons.check_circle,
      );
      // Opcional: regresar al login después de unos segundos
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = '';
      IconData icon = Icons.error;

      switch (e.code) {
        case 'user-not-found':
          message = 'No existe un usuario con ese correo.';
          icon = Icons.person_off;
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido.';
          icon = Icons.alternate_email;
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
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Enviar instrucciones', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Volver al inicio de sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

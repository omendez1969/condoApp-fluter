import 'package:flutter/material.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({Key? key}) : super(key: key);

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _esEspanol = true;

  void _toggleIdioma(bool value) {
    setState(() {
      _esEspanol = value;
    });
    // Aquí puedes poner la lógica para cambiar el idioma de la app globalmente.
    // Por ahora, solo cambia el texto localmente.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Idioma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_esEspanol ? "Español" : "English", style: const TextStyle(fontSize: 16)),
                Switch(
                  value: _esEspanol,
                  onChanged: _toggleIdioma,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Puedes agregar más opciones aquí
          ],
        ),
      ),
    );
  }
}

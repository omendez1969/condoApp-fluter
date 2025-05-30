import 'package:flutter/material.dart';

class VisitasScreen extends StatelessWidget {
  const VisitasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Aquí se gestionan las visitas',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
} 
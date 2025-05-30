import 'package:flutter/material.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Aquí se muestran los avisos',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

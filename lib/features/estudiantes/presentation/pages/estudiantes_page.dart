import 'package:flutter/material.dart';

/// Pantalla Estudiantes.
class EstudiantesPage extends StatelessWidget {
  const EstudiantesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Estudiantes',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

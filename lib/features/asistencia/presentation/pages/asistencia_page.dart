import 'package:flutter/material.dart';

/// Pantalla Asistencia.
class AsistenciaPage extends StatelessWidget {
  const AsistenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Asistencia',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Pantalla Gestión de Usuarios.
class GestionUsuariosPage extends StatelessWidget {
  const GestionUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Gestión de Usuarios',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

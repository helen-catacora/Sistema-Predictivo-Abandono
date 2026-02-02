import 'package:flutter/material.dart';

/// Pantalla Importar Datos.
class ImportarDatosPage extends StatelessWidget {
  const ImportarDatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Importar Datos',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

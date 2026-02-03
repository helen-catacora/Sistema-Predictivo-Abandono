import 'package:flutter/material.dart';

import '../widgets/users_filter_bar.dart';
import '../widgets/users_header.dart';
import '../widgets/users_table.dart';

/// Pantalla Gestión de Usuarios.
class GestionUsuariosPage extends StatelessWidget {
  const GestionUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const UsersHeader(),
          const SizedBox(height: 24),
          const UsersFilterBar(),
          const SizedBox(height: 24),
          const UsersTable(),
        ],
      ),
    );
  }
}

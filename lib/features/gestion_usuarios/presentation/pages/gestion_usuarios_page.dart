import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usuarios_provider.dart';
import '../widgets/users_filter_bar.dart';
import '../widgets/users_header.dart';
import '../widgets/users_table.dart';

/// Pantalla Gestión de Usuarios.
class GestionUsuariosPage extends StatefulWidget {
  const GestionUsuariosPage({super.key});

  @override
  State<GestionUsuariosPage> createState() => _GestionUsuariosPageState();
}

class _GestionUsuariosPageState extends State<GestionUsuariosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuariosProvider>().loadUsuarios();
    });
  }

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

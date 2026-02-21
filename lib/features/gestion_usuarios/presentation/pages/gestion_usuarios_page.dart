import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

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
      // context.read<UsuariosProvider>().loadUsuarios();
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
          const ScreenDescriptionCard(
            description:
                'Administración de usuarios del sistema: altas, edición, roles y módulos de acceso para el sistema de predicción de abandono.',
            icon: Icons.admin_panel_settings_outlined,
          ),
          const SizedBox(height: 24),
          const UsersFilterBar(),
          const SizedBox(height: 24),
          const UsersTable(),
        ],
      ),
    );
  }
}

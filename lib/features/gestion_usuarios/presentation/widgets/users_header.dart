import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/gestion_usuarios/presentation/providers/usuarios_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// Encabezado de la página Gestión de Usuarios.
class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuarios Registrados',
              style: GoogleFonts.inter(
                color: Color(0xff002855),
                fontSize: 36,
                fontWeight: FontWeight.w700,
                height: 40 / 36,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Control de accesos y roles institucionales para el sistema de predicción de abandono estudiantil.',
              style: GoogleFonts.inter(
                color: Color(0xff64748B),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 28 / 18,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        Spacer(),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.userFormNuevo),
          icon: const Icon(Icons.person_add, size: 20),
          label: const Text('AGREGAR USUARIO'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentYellow,
            foregroundColor: AppColors.navyMedium,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(width: 8),
        RefreshButton(
          onTap: () {
            context.read<UsuariosProvider>().loadUsuarios();
          },
        ),
      ],
    );
  }
}

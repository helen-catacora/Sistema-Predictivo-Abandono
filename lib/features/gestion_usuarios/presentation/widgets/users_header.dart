import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/gestion_usuarios/presentation/providers/usuarios_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Encabezado de la página Gestión de Usuarios.
class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = Responsive.isMobile(width);
        final titleFontSize = isMobile ? 22.0 : (Responsive.isTablet(width) ? 26.0 : 30.0);

        final titulo = Text(
          'Gestión de Usuarios',
          style: GoogleFonts.inter(
            color: const Color(0xff002855),
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            height: 36 / 30,
            letterSpacing: 0,
          ),
        );

        final botones = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.userFormNuevo),
              icon: const Icon(Icons.person_add, size: 20),
              label: Text(isMobile ? 'AGREGAR' : 'AGREGAR USUARIO'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.navyMedium,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 14 : 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            RefreshButton(
              onTap: () {
                context.read<UsuariosProvider>().loadUsuarios();
              },
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titulo,
              const SizedBox(height: 12),
              botones,
            ],
          );
        }

        return Row(
          children: [
            titulo,
            const Spacer(),
            botones,
          ],
        );
      },
    );
  }
}

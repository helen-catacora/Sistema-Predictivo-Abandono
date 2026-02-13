import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/menu_item.dart';
import '../widgets/menu_section.dart';
import '../widgets/sidebar_brand.dart';
import '../widgets/sidebar_logout_button.dart';

/// Menú lateral del panel de control.
/// El perfil del usuario se accede desde el ítem "Mi Perfil" en Administración.
/// En la parte inferior solo se muestra el botón Cerrar Sesión.
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.selectedPath});

  final String selectedPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.navyDark,
      child: Column(
        children: [
          const SidebarBrand(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuSection(
                    title: 'MENÚ PRINCIPAL',
                    items: [
                      MenuItem(
                        path: '${AppRoutes.home}/panel',
                        label: 'Panel Principal',
                        icon: Icons.dashboard_outlined,
                        isSelected: selectedPath == '${AppRoutes.home}/panel' ||
                            selectedPath == AppRoutes.home,
                      ),
                      MenuItem(
                        path: '${AppRoutes.home}/estudiantes',
                        label: 'Estudiantes',
                        icon: Icons.people_outline,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/estudiantes',
                      ),
                      MenuItem(
                        path: '${AppRoutes.home}/asistencia',
                        label: 'Asistencia',
                        icon: Icons.checklist_outlined,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/asistencia',
                      ),
                      MenuItem(
                        path: '${AppRoutes.home}/reportes',
                        label: 'Reportes',
                        icon: Icons.assessment_outlined,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/reportes',
                      ),
                    ],
                  ),
                  MenuSection(
                    title: 'GESTIÓN DE DATOS',
                    items: [
                      MenuItem(
                        path: '${AppRoutes.home}/importar-datos',
                        label: 'Importar Datos',
                        icon: Icons.file_download_outlined,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/importar-datos',
                      ),
                    ],
                  ),
                  MenuSection(
                    title: 'ADMINISTRACIÓN',
                    items: [
                      MenuItem(
                        path: '${AppRoutes.home}/gestion-usuarios',
                        label: 'Gestión de Usuarios',
                        icon: Icons.admin_panel_settings_outlined,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/gestion-usuarios',
                      ),
                      MenuItem(
                        path: AppRoutes.homeMiPerfil,
                        label: 'Mi Perfil',
                        icon: Icons.person_outline,
                        isSelected: selectedPath == AppRoutes.homeMiPerfil,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SidebarLogoutButton(
            onPressed: () {
              context.read<AuthProvider>().logout().then((_) {
                if (context.mounted) context.go(AppRoutes.login);
              });
            },
          ),
        ],
      ),
    );
  }
}

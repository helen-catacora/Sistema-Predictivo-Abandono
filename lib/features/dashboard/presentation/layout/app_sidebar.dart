import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/menu_item.dart';
import '../widgets/sidebar_brand.dart';
import '../widgets/menu_section.dart';
import '../widgets/user_profile.dart';

/// Menú lateral del panel de control.
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
                        icon: Icons.person_outline,
                        isSelected:
                            selectedPath == '${AppRoutes.home}/gestion-usuarios',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          UserProfile(
            onLogout: () => context.go(AppRoutes.login),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

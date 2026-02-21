import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/me_provider.dart';
import '../widgets/menu_item.dart';
import '../widgets/menu_section.dart';
import '../widgets/sidebar_brand.dart';
import '../widgets/sidebar_logout_button.dart';

/// Nombres de módulos que devuelve GET /me (coincidir con el backend).
abstract class SidebarModulos {
  static const String visualizacionResultados = 'Visualización de Resultados';
  static const String gestionUsuarios = 'Gestión de Usuarios';
  static const String reportes = 'Reportes';
  static const String gestionDatosEstudiantes =
      'Gestión de Datos de Estudiantes';
  static const String controlAsistencia = 'Control de Asistencia';
}

/// Entrada del menú con el módulo requerido (null = siempre visible).
class _SidebarEntry {
  const _SidebarEntry({
    required this.path,
    required this.label,
    required this.icon,
    this.modulo,
  });
  final String path;
  final String label;
  final IconData icon;
  final String? modulo;
}

/// Menú lateral: solo se muestran ítems cuyos módulos vienen en GET /me.
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.selectedPath});

  final String selectedPath;

  static const List<_SidebarEntry> _menuPrincipal = [
    _SidebarEntry(
      path: AppRoutes.homePanel,
      label: 'Panel Principal',
      icon: Icons.dashboard_outlined,
      modulo: SidebarModulos.visualizacionResultados,
    ),
    _SidebarEntry(
      path: AppRoutes.homeEstudiantes,
      label: 'Estudiantes',
      icon: Icons.people_outline,
      modulo: SidebarModulos.visualizacionResultados,
    ),
    _SidebarEntry(
      path: AppRoutes.homeAsistencia,
      label: 'Asistencia',
      icon: Icons.checklist_outlined,
      modulo: SidebarModulos.controlAsistencia,
    ),
    _SidebarEntry(
      path: AppRoutes.homeReportes,
      label: 'Reportes',
      icon: Icons.assessment_outlined,
      modulo: SidebarModulos.reportes,
    ),
  ];

  static const List<_SidebarEntry> _gestionDatos = [
    _SidebarEntry(
      path: AppRoutes.homeImportarDatos,
      label: 'Importar Datos',
      icon: Icons.file_download_outlined,
      modulo: SidebarModulos.gestionDatosEstudiantes,
    ),
    _SidebarEntry(
      path: AppRoutes.homeParalelos,
      label: 'Paralelos',
      icon: Icons.groups_outlined,
      modulo: SidebarModulos.gestionDatosEstudiantes,
    ),
  ];

  static const List<_SidebarEntry> _administracion = [
    _SidebarEntry(
      path: AppRoutes.homeGestionUsuarios,
      label: 'Gestión de Usuarios',
      icon: Icons.admin_panel_settings_outlined,
      modulo: SidebarModulos.gestionUsuarios,
    ),
    // _SidebarEntry(
    //   path: AppRoutes.homeMiPerfil,
    //   label: 'Mi Perfil',
    //   icon: Icons.person_outline,
    //   modulo: null, // siempre visible
    // ),
  ];

  static bool _tieneModulo(List<String> modulos, String? modulo) {
    if (modulo == null || modulo.isEmpty) return true;
    final m = modulo.trim().toLowerCase();
    return modulos.any((e) => e.trim().toLowerCase() == m);
  }

  /// Primera ruta disponible para el usuario según sus módulos (mismo orden que el sidebar).
  /// Si no tiene acceso a ningún módulo, devuelve [AppRoutes.homeMiPerfil].
  static String firstAvailablePath(List<String> modulos) {
    for (final e in _menuPrincipal) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    for (final e in _gestionDatos) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    for (final e in _administracion) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    return AppRoutes.homeMiPerfil;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeProvider>(
      builder: (context, meProvider, _) {
        final modulos = meProvider.modulos;
        final menuPrincipalItems = _menuPrincipal
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected:
                    selectedPath == e.path ||
                    (e.path == AppRoutes.homePanel &&
                        (selectedPath == AppRoutes.home ||
                            selectedPath == '${AppRoutes.home}/')),
              ),
            )
            .toList();
        final gestionDatosItems = _gestionDatos
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: selectedPath == e.path,
              ),
            )
            .toList();
        final administracionItems = _administracion
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: selectedPath == e.path,
              ),
            )
            .toList();

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
                      if (menuPrincipalItems.isNotEmpty)
                        MenuSection(
                          title: 'MENÚ PRINCIPAL',
                          items: menuPrincipalItems,
                        ),
                      if (gestionDatosItems.isNotEmpty)
                        MenuSection(
                          title: 'GESTIÓN DE DATOS',
                          items: gestionDatosItems,
                        ),
                      if (administracionItems.isNotEmpty)
                        MenuSection(
                          title: 'ADMINISTRACIÓN',
                          items: administracionItems,
                        ),
                    ],
                  ),
                ),
              ),
              SidebarLogoutButton(
                onPressedProfile: () {
                  context.go(AppRoutes.homeMiPerfil);
                },
                onPressedLogout: () {
                  context.read<MeProvider>().clear();
                  context.read<AuthProvider>().logout().then((_) {
                    if (context.mounted) context.go(AppRoutes.login);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

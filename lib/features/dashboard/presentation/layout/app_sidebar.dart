import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/dashboard/presentation/widgets/sidebar_tile.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/me_provider.dart';
import '../widgets/menu_item.dart';
import '../widgets/menu_section.dart';
import '../widgets/sidebar_brand.dart';
import '../widgets/sidebar_logout_button.dart';

const List<_SidebarEntry> _reportes = [
  _SidebarEntry(
    path: AppRoutes.homeReportes,
    label: 'Reportes Disponibles',
    icon: Icons.dashboard_outlined,
    modulo: SidebarModulos.reportes,
  ),
  _SidebarEntry(
    path: AppRoutes.homeHistorialReportes,
    label: 'Historial de Reportes',
    icon: Icons.people_outline,
    modulo: SidebarModulos.reportes,
  ),
];

// static const List<_SidebarEntry> _gestionDeUsuarios = [
//   _SidebarEntry(
//     path: AppRoutes.homePanel,
//     label: 'Reportes Disponibles',
//     icon: Icons.dashboard_outlined,
//     modulo: SidebarModulos.reportes,
//   ),
//   _SidebarEntry(
//     path: AppRoutes.homeEstudiantes,
//     label: 'Historial de Reportes',
//     icon: Icons.people_outline,
//     modulo: SidebarModulos.reportes,
//   ),
// ];
//
const List<_SidebarEntry> _menuPrincipal = [
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

const List<_SidebarEntry> _asistencia = [
  _SidebarEntry(
    path: AppRoutes.homeAsistencia,
    label: 'Registro de Asistencia',
    icon: Icons.checklist_outlined,
    modulo: SidebarModulos.controlAsistencia,
  ),
];

const List<_SidebarEntry> _gestionDatosDelEstudiante = [
  _SidebarEntry(
    path: AppRoutes.homeImportarDatosEstudiantes,
    label: 'Importar Datos para el Registro de Estudiantes',
    icon: Icons.upload_file,
    modulo: SidebarModulos.gestionDatosEstudiantes,
  ),
  _SidebarEntry(
    path: AppRoutes.homeImportarDatos,
    label: 'Importar Datos para la Prediccion',
    icon: Icons.file_upload_outlined,
    modulo: SidebarModulos.gestionDatosEstudiantes,
  ),
  // _SidebarEntry(
  //   path: AppRoutes.homeImportarDatos,
  //   label: 'Importar Datos',
  //   icon: Icons.file_download_outlined,
  //   modulo: SidebarModulos.gestionDatosEstudiantes,
  // ),
  // _SidebarEntry(
  //   path: AppRoutes.homeParalelos,
  //   label: 'Paralelos',
  //   icon: Icons.groups_outlined,
  //   modulo: SidebarModulos.gestionDatosEstudiantes,
  // ),
];

const List<_SidebarEntry> _visualizacionDePredicciones = [
  _SidebarEntry(
    path: AppRoutes.homeEstudiantes,
    label: 'Prediccion por Estudiante',
    icon: Icons.school_outlined,
    modulo: SidebarModulos.visualizacionResultados,
  ),
  _SidebarEntry(
    path: AppRoutes.homeEntrenamientoModelo,
    label: 'Entrenamiento del Modelo',
    icon: Icons.model_training,
    modulo: SidebarModulos.visualizacionResultados,
  ),
];

const List<_SidebarEntry> _configuracionAcademica = [
  _SidebarEntry(
    path: AppRoutes.homeImportarDatosMallaCurricular,
    label: 'Importar Malla Curricular',
    icon: Icons.file_upload_outlined,
    modulo: SidebarModulos.configuracionAcademica,
  ),
  _SidebarEntry(
    path: AppRoutes.homeParalelos,
    label: 'Configuración de Paralelos',
    icon: Icons.file_upload_outlined,
    modulo: SidebarModulos.configuracionAcademica,
  ),
];

const List<_SidebarEntry> _administracion = [
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

bool _tieneModulo(List<String> modulos, String? modulo) {
  if (modulo == null || modulo.isEmpty) return true;
  final m = modulo.trim().toLowerCase();
  return modulos.any((e) => e.trim().toLowerCase() == m);
}

/// Nombres de módulos que devuelve GET /me (coincidir con el backend).
abstract class SidebarModulos {
  static const String visualizacionResultados = 'Predicciones';
  static const String gestionUsuarios = 'Gestión de Usuarios';
  static const String reportes = 'Reportes';
  static const String gestionDatosEstudiantes =
      'Gestión de Datos de Estudiantes';
  static const String controlAsistencia = 'Registro de Asistencia';
  static const String configuracionAcademica = 'Configuracion Academica';
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
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.selectedPath,
    this.isCollapsed = false,
    this.onToggle,
    this.onNavigated,
    this.showToggle = true,
  });

  final String selectedPath;
  final bool isCollapsed;
  final VoidCallback? onToggle;
  final VoidCallback? onNavigated;
  final bool showToggle;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
  static String firstAvailablePath(List<String> modulos) {
    for (final e in _menuPrincipal) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    for (final e in _gestionDatosDelEstudiante) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    for (final e in _administracion) {
      if (_tieneModulo(modulos, e.modulo)) return e.path;
    }
    return AppRoutes.homeMiPerfil;
  }
}

class _AppSidebarState extends State<AppSidebar> {
  bool _showText = false;
  static const _animDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _showText = !widget.isCollapsed;
  }

  @override
  void didUpdateWidget(AppSidebar old) {
    super.didUpdateWidget(old);
    if (old.isCollapsed == widget.isCollapsed) return;

    if (widget.isCollapsed) {
      // Colapsando: ocultar textos inmediatamente
      setState(() => _showText = false);
    } else {
      // Expandiendo: esperar a que el AnimatedContainer termine
      Future.delayed(_animDuration, () {
        if (mounted) setState(() => _showText = true);
      });
    }
  }

  /// Primera ruta disponible para el usuario según sus módulos (mismo orden que el sidebar).
  /// Si no tiene acceso a ningún módulo, devuelve [AppRoutes.homeMiPerfil]

  @override
  Widget build(BuildContext context) {
    // Los tiles usan effectiveCollapsed para no mostrar texto durante la animación.
    // SidebarBrand maneja su propio delay internamente → recibe el isCollapsed real.
    final effectiveCollapsed = widget.isCollapsed || !_showText;

    return Consumer<MeProvider>(
      builder: (context, meProvider, _) {
        final modulos = meProvider.modulos;
        final configuracionAcademica = _configuracionAcademica
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: widget.selectedPath == e.path,
              ),
            )
            .toList();
        final asistencia = _asistencia
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: widget.selectedPath == e.path,
              ),
            )
            .toList();
        final esPanelSeleccionado = widget.selectedPath == AppRoutes.homePanel;
        final panelPrincipalItem = MenuItem(
          path: AppRoutes.homePanel,
          label: 'Panel Predictivo',
          icon: Icons.show_chart_outlined,
          isSelected: esPanelSeleccionado,
          children: [
            MenuItem(
              path: '${AppRoutes.homePanel}?seccion=estado_academico',
              label: 'Estado Académico',
              icon: Icons.school_outlined,
              isSelected: false,
            ),
            MenuItem(
              path: '${AppRoutes.homePanel}?seccion=distribucion_riesgo',
              label: 'Distribución de riesgo',
              icon: Icons.show_chart,
              isSelected: false,
            ),
            MenuItem(
              path: '${AppRoutes.homePanel}?seccion=alertas_criticas',
              label: 'Alertas Críticas',
              icon: Icons.warning_amber_rounded,
              isSelected: false,
            ),
            MenuItem(
              path: '${AppRoutes.homePanel}?seccion=resumen_paralelo',
              label: 'Resumen por Paralelo',
              icon: Icons.groups_outlined,
              isSelected: false,
            ),
          ],
        );
        final visualizacionDePredicciones = [
          if (_tieneModulo(modulos, SidebarModulos.visualizacionResultados))
            panelPrincipalItem,
          ..._visualizacionDePredicciones
              .where((e) => _tieneModulo(modulos, e.modulo))
              .map(
                (e) => MenuItem(
                  path: e.path,
                  label: e.label,
                  icon: e.icon,
                  isSelected: widget.selectedPath == e.path,
                ),
              ),
        ];
        final reportesItems = _reportes
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: widget.selectedPath == e.path,
              ),
            )
            .toList();
        // final menuPrincipalItems = _menuPrincipal
        //     .where((e) => _tieneModulo(modulos, e.modulo))
        //     .map(
        //       (e) => MenuItem(
        //         path: e.path,
        //         label: e.label,
        //         icon: e.icon,
        //         isSelected:
        //             selectedPath == e.path ||
        //             (e.path == AppRoutes.homePanel &&
        //                 (selectedPath == AppRoutes.home ||
        //                     selectedPath == '${AppRoutes.home}/')),
        //       ),
        //     )
        //     .toList();
        final gestionDatosDelEstudianteItems = _gestionDatosDelEstudiante
            .where((e) => _tieneModulo(modulos, e.modulo))
            .map(
              (e) => MenuItem(
                path: e.path,
                label: e.label,
                icon: e.icon,
                isSelected: widget.selectedPath == e.path,
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
                isSelected: widget.selectedPath == e.path,
              ),
            )
            .toList();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: widget.isCollapsed ? 70 : 260,
          color: AppColors.navyDark,
          child: Column(
            children: [
              SidebarBrand(
                isCollapsed: widget.isCollapsed,
                onToggle: widget.onToggle,
                showToggle: widget.showToggle,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (administracionItems.isNotEmpty)
                        SidebarTile(
                          item: administracionItems.first,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                        ),
                      if (gestionDatosDelEstudianteItems.isNotEmpty)
                        SidebarSectionExpansionTile(
                          title: 'Gestion de Datos de Estudiantes',
                          icon: Icons.dashboard_outlined,
                          items: gestionDatosDelEstudianteItems,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                          onExpand: widget.onToggle,
                        ),
                      if (visualizacionDePredicciones.isNotEmpty)
                        SidebarSectionExpansionTile(
                          title: 'Predicciones',
                          icon: Icons.dashboard_outlined,
                          items: visualizacionDePredicciones,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                          onExpand: widget.onToggle,
                        ),
                      if (asistencia.isNotEmpty)
                        SidebarTile(
                          item: asistencia.first,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                        ),
                      if (configuracionAcademica.isNotEmpty)
                        SidebarSectionExpansionTile(
                          title: 'Gestión Académica',
                          icon: Icons.dashboard_outlined,
                          items: configuracionAcademica,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                          onExpand: widget.onToggle,
                        ),
                      if (reportesItems.isNotEmpty)
                        SidebarSectionExpansionTile(
                          title: 'Reportes',
                          icon: Icons.dashboard_outlined,
                          items: reportesItems,
                          isCollapsed: effectiveCollapsed,
                          onNavigated: widget.onNavigated,
                          onExpand: widget.onToggle,
                        ),
                    ],
                  ),
                ),
              ),
              SidebarLogoutButton(
                isCollapsed: effectiveCollapsed,
                onPressedProfile: () {
                  context.go(AppRoutes.homeMiPerfil);
                  widget.onNavigated?.call();
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

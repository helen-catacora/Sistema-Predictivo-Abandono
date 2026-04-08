import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/materias_provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/paralelos_provider.dart';
import 'package:sistemapredictivoabandono/features/auth/presentation/providers/me_provider.dart';
import 'package:sistemapredictivoabandono/features/estudiantes/presentation/providers/estudiantes_provider.dart';
import 'package:sistemapredictivoabandono/features/gestion_usuarios/presentation/providers/usuarios_provider.dart';
import 'package:sistemapredictivoabandono/features/panel_principal/presentation/providers/alertas_provider.dart';
import 'package:sistemapredictivoabandono/features/panel_principal/presentation/providers/dashboard_provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_historial_provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_tipos_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../gestion_usuarios/presentation/providers/modulos_provider.dart';
import 'app_sidebar.dart';
import '../widgets/dashboard_footer.dart';
import '../widgets/dashboard_header.dart';

/// Layout principal con menú lateral y área de contenido.
/// Al montarse, dispara la carga única de módulos (GET /modulos) para el formulario de usuarios.
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key, required this.child});

  final Widget child;

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _redirectToFirstAvailableDone = false;
  bool _desktopSidebarCollapsed = false; // desktop empieza expandido
  bool _tabletSidebarCollapsed = true;   // tablet empieza colapsado
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeProvider>().loadMe();
      context.read<DashboardProvider>().loadDashboard();
      context.read<AlertasProvider>().loadAlertas();
      context.read<EstudiantesProvider>().loadEstudiantes();
      context.read<ParalelosProvider>().loadParalelos();
      context.read<MateriasProvider>().loadMaterias();
      context.read<ReportesTiposProvider>().loadTipos();
      context.read<ReportesHistorialProvider>().loadHistorial(
        page: 1,
        pageSize: 20,
      );
      context.read<UsuariosProvider>().loadUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final meProvider = context.watch<MeProvider>();

    if (meProvider.status == MeStatus.success &&
        !_redirectToFirstAvailableDone &&
        (location == AppRoutes.homePanel ||
            location == AppRoutes.home ||
            location == '${AppRoutes.home}/')) {
      final modulos = meProvider.modulos;
      final tienePanel = AppSidebar.firstAvailablePath(modulos) == AppRoutes.homePanel;
      if (!tienePanel) {
        _redirectToFirstAvailableDone = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go(AppSidebar.firstAvailablePath(modulos));
          }
        });
      } else {
        _redirectToFirstAvailableDone = true;
      }
    }

    return ModulosLoader(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = Responsive.isMobile(width);
          final isTablet = Responsive.isTablet(width);

          final sidebarCollapsed = isMobile
              ? false
              : (isTablet ? _tabletSidebarCollapsed : _desktopSidebarCollapsed);

          Widget sidebarWidget({VoidCallback? onNavigated}) => AppSidebar(
            selectedPath: location,
            isCollapsed: sidebarCollapsed,
            onToggle: () => setState(() {
              if (isTablet) {
                _tabletSidebarCollapsed = !_tabletSidebarCollapsed;
              } else {
                _desktopSidebarCollapsed = !_desktopSidebarCollapsed;
              }
            }),
            onNavigated: onNavigated,
            showToggle: !isMobile,
          );

          return Scaffold(
            key: _scaffoldKey,
            drawer: isMobile
                ? Drawer(
                    child: sidebarWidget(
                      onNavigated: () =>
                          _scaffoldKey.currentState?.closeDrawer(),
                    ),
                  )
                : null,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) sidebarWidget(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DashboardHeader(
                        showMenuButton: isMobile,
                        onMenuPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Expanded(
                        child: Container(
                          color: AppColors.grayLight,
                          padding: Responsive.contentPadding(width),
                          child: widget.child,
                        ),
                      ),
                      const DashboardFooter(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Dispara la carga de módulos una única vez al entrar al home.
class ModulosLoader extends StatefulWidget {
  const ModulosLoader({super.key, required this.child});

  final Widget child;

  @override
  State<ModulosLoader> createState() => _ModulosLoaderState();
}

class _ModulosLoaderState extends State<ModulosLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModulosProvider>().loadModulos();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

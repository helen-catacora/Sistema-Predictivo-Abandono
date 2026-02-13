import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/asistencia/presentation/pages/asistencia_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/layout/dashboard_layout.dart';
import '../../features/dashboard/presentation/pages/mi_perfil_page.dart';
import '../../features/estudiantes/presentation/pages/estudiante_perfil_page.dart';
import '../../features/estudiantes/presentation/pages/estudiantes_page.dart';
import '../../features/gestion_usuarios/data/models/usuario_item.dart';
import '../../features/gestion_usuarios/presentation/pages/gestion_usuarios_page.dart';
import '../../features/gestion_usuarios/presentation/pages/user_form_page.dart';
import '../../features/importar_datos/presentation/pages/importar_datos_page.dart';
import '../../features/panel_principal/presentation/pages/panel_principal_page.dart';
import '../../features/reportes/presentation/pages/reportes_page.dart';

/// Rutas de la aplicación.
abstract class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String homePanel = '/home/panel';
  static const String homeEstudiantes = '/home/estudiantes';
  static String homeEstudiantePerfil(int id) => '/home/estudiantes/perfil/$id';
  static const String homeAsistencia = '/home/asistencia';
  static const String homeReportes = '/home/reportes';
  static const String homeImportarDatos = '/home/importar-datos';
  static const String homeGestionUsuarios = '/home/gestion-usuarios';
  static const String homeMiPerfil = '/home/mi-perfil';
  static const String userFormNuevo = '/home/gestion-usuarios/nuevo';
  static const String userFormEditar = '/home/gestion-usuarios/editar';
}

/// Crea el router con lógica de redirección según autenticación.
GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoginRoute = state.uri.path == AppRoutes.login;
      if (!isLoggedIn && !isLoginRoute) return AppRoutes.login;
      if (isLoggedIn && isLoginRoute) return AppRoutes.homePanel;
      return null;
    },
    routes: _routes,
  );
}

final List<RouteBase> _routes = [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => DashboardLayout(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          redirect: (context, state) {
            final loc = state.uri.path;
            if (loc == AppRoutes.home || loc == '${AppRoutes.home}/') {
              return AppRoutes.homePanel;
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'panel',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const PanelPrincipalPage(),
              ),
            ),
            GoRoute(
              path: 'estudiantes',
              routes: [
                GoRoute(
                  path: 'perfil/:id',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '0';
                    final estudianteId = int.tryParse(id) ?? 0;
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: EstudiantePerfilPage(estudianteId: estudianteId),
                    );
                  },
                ),
              ],
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const EstudiantesPage(),
              ),
            ),
            GoRoute(
              path: 'asistencia',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const AsistenciaPage(),
              ),
            ),
            GoRoute(
              path: 'reportes',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ReportesPage(),
              ),
            ),
            GoRoute(
              path: 'importar-datos',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ImportarDatosPage(),
              ),
            ),
            GoRoute(
              path: 'mi-perfil',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const MiPerfilPage(),
              ),
            ),
            GoRoute(
              path: 'gestion-usuarios',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const GestionUsuariosPage(),
              ),
              routes: [
                GoRoute(
                  path: 'nuevo',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const UserFormPage(),
                  ),
                ),
                GoRoute(
                  path: 'editar',
                  pageBuilder: (context, state) {
                    final usuario = state.extra as UsuarioItem?;
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: UserFormPage(usuario: usuario),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

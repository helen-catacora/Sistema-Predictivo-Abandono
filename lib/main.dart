import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'features/asistencia/presentation/providers/asistencias_provider.dart';
import 'features/asistencia/presentation/providers/materias_provider.dart';
import 'features/asistencia/presentation/providers/paralelos_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/me_provider.dart';
import 'features/estudiantes/presentation/providers/estudiantes_provider.dart';
import 'features/importar_datos/presentation/providers/importar_estudiantes_provider.dart';
import 'features/importar_datos/presentation/providers/importar_malla_curricular_provider.dart';
import 'features/importar_datos/presentation/providers/importar_predicciones_provider.dart';
import 'features/gestion_usuarios/presentation/providers/modulos_provider.dart';
import 'features/gestion_usuarios/presentation/providers/usuarios_provider.dart';
import 'features/panel_principal/presentation/providers/alertas_provider.dart';
import 'features/panel_principal/presentation/providers/dashboard_provider.dart';
import 'features/reportes/presentation/providers/reportes_historial_provider.dart';
import 'features/reportes/presentation/providers/reportes_tipos_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenStorage.ensureInit();

  final authProvider = AuthProvider();
  authProvider.checkAuthStatus();

  runApp(
    MyApp(
      router: createAppRouter(authProvider),
      authProvider: authProvider,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.router,
    required this.authProvider,
  });

  final GoRouter router;
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => MeProvider()),
        ChangeNotifierProvider(create: (_) => EstudiantesProvider()),
        ChangeNotifierProvider(create: (_) => ParalelosProvider()),
        ChangeNotifierProvider(create: (_) => MateriasProvider()),
        ChangeNotifierProvider(create: (_) => AsistenciasProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
        ChangeNotifierProvider(create: (_) => ModulosProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AlertasProvider()),
        ChangeNotifierProvider(create: (_) => ReportesTiposProvider()),
        ChangeNotifierProvider(create: (_) => ReportesHistorialProvider()),
        ChangeNotifierProvider(create: (_) => ImportarPrediccionesProvider()),
        ChangeNotifierProvider(create: (_) => ImportarEstudiantesProvider()),
        ChangeNotifierProvider(
            create: (_) => ImportarMallaCurricularProvider()),
      ],
      child: MaterialApp.router(
        title: 'Sistema Predictivo de Abandono Estudiantil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B263B),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}

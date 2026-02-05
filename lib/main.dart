import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'features/asistencia/presentation/providers/asistencias_provider.dart';
import 'features/asistencia/presentation/providers/materias_provider.dart';
import 'features/asistencia/presentation/providers/paralelos_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/estudiantes/presentation/providers/estudiantes_provider.dart';
import 'features/gestion_usuarios/presentation/providers/usuarios_provider.dart';

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
        ChangeNotifierProvider(create: (_) => EstudiantesProvider()),
        ChangeNotifierProvider(create: (_) => ParalelosProvider()),
        ChangeNotifierProvider(create: (_) => MateriasProvider()),
        ChangeNotifierProvider(create: (_) => AsistenciasProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
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

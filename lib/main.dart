import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

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
    return ChangeNotifierProvider<AuthProvider>.value(
      value: authProvider,
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

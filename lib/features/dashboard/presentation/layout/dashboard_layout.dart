import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../gestion_usuarios/presentation/providers/modulos_provider.dart';
import 'app_sidebar.dart';
import '../widgets/dashboard_footer.dart';
import '../widgets/dashboard_header.dart';

/// Layout principal con menú lateral y área de contenido.
/// Al montarse, dispara la carga única de módulos (GET /modulos) para el formulario de usuarios.
class DashboardLayout extends StatelessWidget {
  const DashboardLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return ModulosLoader(
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSidebar(selectedPath: location),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DashboardHeader(),
                  Expanded(
                    child: Container(
                      color: AppColors.grayLight,
                      padding: const EdgeInsets.all(24),
                      child: child,
                    ),
                  ),
                  const DashboardFooter(),
                ],
              ),
            ),
          ],
        ),
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

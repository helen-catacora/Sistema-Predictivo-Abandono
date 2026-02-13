import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/router/app_router.dart';

/// Barra superior de la página Mi Perfil: título y botones de acción.
class MiPerfilHeader extends StatelessWidget {
  const MiPerfilHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.navyDark,
      child: Row(
        children: [
          const Text(
            'PERFIL DE USUARIO',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _HeaderButton(
            icon: Icons.psychology_outlined,
            label: 'NUEVA PREDICCIÓN',
            onPressed: () => context.go(AppRoutes.homePanel),
          ),
          const SizedBox(width: 12),
          _HeaderButton(
            icon: Icons.history,
            label: 'VER HISTORIAL',
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          _HeaderButton(
            icon: Icons.table_chart_outlined,
            label: 'CARGAR EXCEL',
            onPressed: () => context.go(AppRoutes.homeImportarDatos),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.navyMedium,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: AppColors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

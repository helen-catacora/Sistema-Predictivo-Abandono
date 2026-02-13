import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// Encabezado del panel de control con línea amarilla y acciones.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isPanel =
        GoRouterState.of(context).matchedLocation == AppRoutes.homePanel ||
        GoRouterState.of(context).matchedLocation == AppRoutes.home;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.navyDark,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'PANEL DE CONTROL PREDICTIVO',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (isPanel) ...[
            // _HeaderButton(
            //   icon: Icons.psychology_outlined,
            //   label: 'NUEVA PREDICCIÓN',
            //   onPressed: () {},
            // ),
            // const SizedBox(width: 12),
            // _HeaderButton(
            //   icon: Icons.history,
            //   label: 'VER HISTORIAL',
            //   onPressed: () {},
            // ),
            // const SizedBox(width: 12),
            // _HeaderButton(
            //   icon: Icons.description_outlined,
            //   label: 'CARGAR EXCEL',
            //   onPressed: () {},
            // ),
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

class HeaderButton extends StatelessWidget {
  const HeaderButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: AppColors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }
}

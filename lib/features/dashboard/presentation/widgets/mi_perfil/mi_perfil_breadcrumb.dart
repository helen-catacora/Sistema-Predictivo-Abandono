import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/router/app_router.dart';

/// Breadcrumb: Inicio > Administración > Mi Perfil
class MiPerfilBreadcrumb extends StatelessWidget {
  const MiPerfilBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: AppColors.grayLight,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go(AppRoutes.homePanel),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home_outlined, size: 18, color: AppColors.grayDark),
                const SizedBox(width: 6),
                Text(
                  'Inicio',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '>',
              style: TextStyle(color: AppColors.grayMedium, fontSize: 14),
            ),
          ),
          Text(
            'Administración',
            style: TextStyle(
              color: AppColors.grayDark,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '>',
              style: TextStyle(color: AppColors.grayMedium, fontSize: 14),
            ),
          ),
          Text(
            'Mi Perfil',
            style: TextStyle(
              color: AppColors.navyMedium,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

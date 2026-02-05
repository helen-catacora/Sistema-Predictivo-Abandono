import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// Encabezado de la página Gestión de Usuarios.
class UsersHeader extends StatelessWidget {
  const UsersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuarios Registrados',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Control de accesos y roles institucionales para el sistema de predicción de deserción.',
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 14,
              ),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.userFormNuevo),
          icon: const Icon(Icons.person_add, size: 20),
          label: const Text('AGREGAR USUARIO'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentYellow,
            foregroundColor: AppColors.navyMedium,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

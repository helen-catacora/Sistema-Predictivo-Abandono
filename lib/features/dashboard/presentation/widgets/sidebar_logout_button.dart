import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Botón "Cerrar Sesión" en la parte inferior del sidebar.
class SidebarLogoutButton extends StatelessWidget {
  const SidebarLogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.logout, size: 20, color: AppColors.navyDark),
          label: const Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: AppColors.navyDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: AppColors.navyDark),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

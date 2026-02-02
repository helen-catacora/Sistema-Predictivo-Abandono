import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado del panel de control.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.navyMedium,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'PANEL DE CONTROL PREDICTIVO',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

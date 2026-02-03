import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado del Centro de Reportes.
class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'REPORTES Y ANÁLISIS',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Centro de Reportes',
          style: TextStyle(
            color: AppColors.navyMedium,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ANÁLISIS INTEGRAL DE DESERCIÓN ESTUDIANTIL - GESTIÓN 2024',
          style: TextStyle(
            color: AppColors.grayMedium,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

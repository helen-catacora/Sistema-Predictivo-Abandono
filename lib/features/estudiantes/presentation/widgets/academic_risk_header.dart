import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de la página Estudiantes en Riesgo Académico.
class AcademicRiskHeader extends StatelessWidget {
  const AcademicRiskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estudiantes en Riesgo Académico',
          style: TextStyle(
            color: AppColors.navyMedium,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monitoreo de indicadores críticos y probabilidad de deserción en Ciencias Básicas.',
          style: TextStyle(
            color: AppColors.grayMedium,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

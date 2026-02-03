import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado principal de la página Importar Datos.
class ImportPageHeader extends StatelessWidget {
  const ImportPageHeader({super.key});

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
              'IMPORTACIÓN DE DATOS',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Importar Datos para Predicción',
          style: TextStyle(
            color: AppColors.navyMedium,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'CARGUE ARCHIVOS CON INFORMACIÓN ESTUDIANTIL PARA ANÁLISIS PREDICTIVO',
          style: TextStyle(
            color: AppColors.grayMedium,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de la página Registro de Asistencia.
class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.school_outlined, color: AppColors.navyMedium, size: 24),
            const SizedBox(width: 8),
            Text(
              'Registro Diario de Asistencia',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'EMI Ciencias Básicas > Control de Asistencia',
          style: TextStyle(
            color: AppColors.grayMedium,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REGISTRO DE ASISTENCIA',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Exportar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navyMedium,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Guardar Registro'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

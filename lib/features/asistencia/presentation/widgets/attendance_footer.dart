import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Pie de página del registro de asistencia.
class AttendanceFooter extends StatelessWidget {
  const AttendanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.cloud_done,
              size: 20,
              color: const Color(0xFF22C55E),
            ),
            const SizedBox(width: 8),
            Text(
              'Borrador guardado automáticamente a las 10:45 AM',
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navyMedium,
              ),
              child: const Text('Cancelar'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navyMedium,
              ),
              child: const Text('Finalizar Registro'),
            ),
          ],
        ),
      ],
    );
  }
}

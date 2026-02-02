import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección de búsqueda y filtros para estudiantes.
class StudentFilterSection extends StatelessWidget {
  const StudentFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUSCAR ESTUDIANTE',
                    style: TextStyle(
                      color: AppColors.grayDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nombre, ID o correo electrónico...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FACULTAD / CARRERA',
                    style: TextStyle(
                      color: AppColors.grayDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: 'todas',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'todas',
                        child: Text('Todas las Carreras'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune, size: 20),
              label: const Text('Filtros Avanzados'),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.blueLight,
                foregroundColor: AppColors.navyMedium,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

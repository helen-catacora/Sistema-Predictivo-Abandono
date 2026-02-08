import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Panel derecho: Última Importación, Estadísticas, Campos Requeridos/Opcionales.
class CreacionEstudiantesSidebar extends StatelessWidget {
  const CreacionEstudiantesSidebar({super.key});

  static const _requiredFields = [
    'ID Estudiante',
    'Nombres Completos',
    'Apellidos',
    'Email Institucional',
    'Teléfono',
    'Dirección',
    'Semestre / Nivel',
  ];

  static const _optionalFields = [
    'Fecha de Nacimiento',
    'Carrera',
    'Contacto de Emergencia',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LastImportCard(
          date: '10/01/2024',
          records: '342',
          fileName: 'nuevos_estudiantes.xlsx',
          success: true,
        ),
        const SizedBox(height: 16),
        const _StatisticsCard(),
        const SizedBox(height: 16),
        const _RequiredOptionalFieldsCard(
          requiredFields: _requiredFields,
          optionalFields: _optionalFields,
        ),
      ],
    );
  }
}

class _LastImportCard extends StatelessWidget {
  const _LastImportCard({
    required this.date,
    required this.records,
    required this.fileName,
    required this.success,
  });

  final String date;
  final String records;
  final String fileName;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: success ? const Color(0xFF22C55E) : const Color(0xFFEAB308),
            width: 4,
          ),
          top: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: success ? const Color(0xFF22C55E) : const Color(0xFFEAB308),
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Última Importación',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              success ? 'Exitosa' : 'Con errores',
              style: TextStyle(
                color: success ? const Color(0xFF22C55E) : const Color(0xFFEAB308),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text('Fecha: $date', style: _detailStyle),
            Text('Registros: $records', style: _detailStyle),
            Text('Archivo: $fileName', style: _detailStyle),
          ],
        ),
      ),
    );
  }

  static const _detailStyle = TextStyle(
    color: AppColors.navyMedium,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: const BorderSide(color: AppColors.accentYellow, width: 4),
          top: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, color: AppColors.accentYellow, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Estadísticas',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estudiantes Registrados',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              '23',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'IMPORTACIONES REALIZADAS',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequiredOptionalFieldsCard extends StatelessWidget {
  const _RequiredOptionalFieldsCard({
    required this.requiredFields,
    required this.optionalFields,
  });

  final List<String> requiredFields;
  final List<String> optionalFields;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: AppColors.navyMedium, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Campos Requeridos',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...requiredFields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(f, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'CAMPOS OPCIONALES',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...optionalFields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Radio<String>(
                        value: f,
                        groupValue: null,
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(f, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

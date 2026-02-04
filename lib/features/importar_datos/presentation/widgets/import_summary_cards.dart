import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tarjetas de resumen: Última Importación, Estadísticas, Campos Requeridos.
class ImportSummaryCards extends StatelessWidget {
  const ImportSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LastImportCard(
          date: '15/01/2024',
          records: '1,248',
          fileName: 'estudiantes_2024.xlsx',
          success: true,
        ),
        const SizedBox(height: 16),
        const _StatisticsCard(),
        const SizedBox(height: 16),
        const _RequiredFieldsCard(),
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
    final statusColor = success
        ? const Color(0xFF22C55E)
        : const Color(0xFFEAB308);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: statusColor, size: 40),
            const SizedBox(width: 16),
            Text(
              success ? 'Exitosa' : 'Con errores',
              style: TextStyle(
                color: statusColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Fecha: $date', style: _boldStyle),
                Text('Registros: $records', style: _boldStyle),
                Text('Archivo: $fileName', style: _boldStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const _boldStyle = TextStyle(
    color: AppColors.navyMedium,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: AppColors.accentYellow, size: 24),
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
              'Total de Importaciones',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  '47',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'CARGAS REALIZADAS',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequiredFieldsCard extends StatelessWidget {
  const _RequiredFieldsCard();

  static const _requiredFields = [
    'ID Estudiante',
    'Nombres Completos',
    'Apellidos',
    'Semestre / Nivel',
    'Promedio General',
    'Porcentaje Asistencia',
  ];

  static const _optionalFields = [
    'Email Institucional',
    'Teléfono',
    'Dirección',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
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
            ..._requiredFields.map(
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
            ..._optionalFields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Radio<String>(value: f),
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

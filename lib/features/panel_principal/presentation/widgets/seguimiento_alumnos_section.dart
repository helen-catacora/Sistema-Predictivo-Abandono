import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección Seguimiento de Alumnos con tabla.
class SeguimientoAlumnosSection extends StatelessWidget {
  const SeguimientoAlumnosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.navyMedium,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Seguimiento de Alumnos',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filtrar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.grayDark,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Exportar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.grayLight),
                columns: const [
                  DataColumn(label: Text('ESTUDIANTE')),
                  DataColumn(label: Text('NIVEL / SEMESTRE')),
                  DataColumn(label: Text('ASISTENCIA')),
                  DataColumn(label: Text('NIVEL DE RIESGO')),
                  DataColumn(label: Text('ACCIONES')),
                ],
                rows: [
                  _buildRow(
                    'ALVAREZ, CARLOS',
                    'ID: 2024-0015',
                    '2DO SEMESTRE',
                    'CIENCIAS EXACTAS',
                    85,
                    true,
                    65,
                    false,
                  ),
                  _buildRow(
                    'ROJAS, ANA LUCÍA',
                    'ID: 2024-0128',
                    '1ER SEMESTRE',
                    'TECNOLOGÍA',
                    62,
                    false,
                    82,
                    true,
                  ),
                  _buildRow(
                    'TORRES, MARCOS',
                    'ID: 2024-0542',
                    '3ER SEMESTRE',
                    'INGENIERÍA',
                    91,
                    true,
                    45,
                    false,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              'Ver todos los estudiantes',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(
    String name,
    String id,
    String nivel,
    String carrera,
    int asistencia,
    bool asistenciaOk,
    int riesgo,
    bool riesgoAlto,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                id,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nivel),
              Text(
                carrera,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$asistencia%',
                  style: TextStyle(
                    color: asistenciaOk ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                _ProgressBar(
                  value: asistencia / 100,
                  isHigh: asistenciaOk,
                ),
              ],
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$riesgo%',
                  style: TextStyle(
                    color: riesgoAlto ? Colors.red : AppColors.navyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                _ProgressBar(
                  value: riesgo / 100,
                  isHigh: riesgoAlto,
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.isHigh});

  final double value;
  final bool isHigh;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            isHigh ? Colors.red : AppColors.navyMedium,
          ),
        ),
      ),
    );
  }
}

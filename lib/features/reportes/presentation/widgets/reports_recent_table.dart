import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tabla de reportes generados recientemente.
class ReportsRecentTable extends StatelessWidget {
  const ReportsRecentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Reportes Generados Recientemente',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFF2C3E50)),
                columns: const [
                  DataColumn(
                    label: Text(
                      'NOMBRE DEL REPORTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'TIPO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'GENERADO POR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'FECHA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ESTADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ACCIONES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: [
                  _buildRow(
                    'Reporte Predictivo Q1 2024',
                    'PREDICTIVO',
                    AppColors.navyMedium,
                    'Cnl. Admin EMI',
                    '15/01/2024 10:30',
                  ),
                  _buildRow(
                    'Listado Estudiantes Riesgo',
                    'LISTADO',
                    AppColors.accentYellow,
                    'Lic. Rojas',
                    '14/01/2024 15:45',
                  ),
                  _buildRow(
                    'Análisis por Carrera',
                    'ANÁLISIS',
                    Colors.purple,
                    'Cnl. Admin EMI',
                    '14/01/2024 09:20',
                  ),
                  _buildRow(
                    'Asistencia Diciembre',
                    'ASISTENCIA',
                    Colors.red,
                    'Lic. Rojas',
                    '13/01/2024 16:00',
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mostrando 4 de 247 reportes',
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Ver historial completo',
                style: TextStyle(
                  color: AppColors.navyMedium,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  DataRow _buildRow(
    String nombre,
    String tipo,
    Color tipoColor,
    String generadoPor,
    String fecha,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(nombre)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tipoColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tipo,
              style: TextStyle(
                color: tipoColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.grayLight,
                child: Text(
                  generadoPor[0],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(generadoPor),
            ],
          ),
        ),
        DataCell(Text(fecha)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'COMPLETADO',
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

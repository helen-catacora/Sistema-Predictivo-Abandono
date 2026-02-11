import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/features/importar_datos/presentation/widgets/import_section_header.dart';

import '../import_history_table.dart';

/// Tabla de historial de importaciones para creación de estudiantes.
class CreacionEstudiantesHistorialTable extends StatelessWidget {
  const CreacionEstudiantesHistorialTable({super.key});

  static final _sampleData = [
    const ImportHistoryRow(
      date: '10/01/2024 10:15 hrs',
      fileName: 'nuevos_estudiantes.xlsx',
      fileType: 'xlsx',
      records: '342',
      success: true,
      user: 'Admin EMI',
    ),
    const ImportHistoryRow(
      date: '09/01/2024 14:30 hrs',
      fileName: 'estudiantes_transferencia.csv',
      fileType: 'csv',
      records: '89',
      success: true,
      user: 'L. Rojas',
    ),
    const ImportHistoryRow(
      date: '08/01/2024 09:00 hrs',
      fileName: 'estudiantes_nuevos.json',
      fileType: 'json',
      records: '456',
      success: true,
      user: 'M. Torres',
    ),
    const ImportHistoryRow(
      date: '05/01/2024 16:45 hrs',
      fileName: 'matricula_sem1.xlsx',
      fileType: 'xlsx',
      records: '125',
      success: true,
      user: 'Admin EMI',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: Color(0xff023E8A), width: 4)),
      ),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          ImportSectionHeader(title: 'Historial de Importaciones'),
          SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xff002855),
                      ),
                      columns: const [
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
                            'ARCHIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'REGISTROS',
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
                            'USUARIO',
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
                      rows: _sampleData
                          .map(
                            (r) => DataRow(
                              color: WidgetStateProperty.all(
                                const Color(0xffF1F5F9),
                              ),
                              cells: [
                                DataCell(Text(r.date)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _fileIcon(r.fileType),
                                        size: 20,
                                        color: _fileColor(r.fileType),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(r.fileName),
                                    ],
                                  ),
                                ),
                                DataCell(Text(r.records)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: r.success
                                              ? const Color(0xFF22C55E)
                                              : const Color(0xFFEAB308),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        r.success ? 'EXITOSO' : 'CON ERRORES',
                                        style: TextStyle(
                                          color: r.success
                                              ? const Color(0xFF22C55E)
                                              : const Color(0xFFEAB308),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(r.user)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.download,
                                          size: 20,
                                          color: Colors.grey.shade600,
                                        ),
                                        tooltip: 'Descargar',
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.visibility,
                                          size: 20,
                                          color: Colors.grey.shade600,
                                        ),
                                        tooltip: 'Ver',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Ver todo el historial',
                style: TextStyle(
                  color: AppColors.navyMedium,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _fileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'xlsx':
      case 'xls':
        return Icons.table_chart;
      case 'csv':
        return Icons.description;
      case 'json':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _fileColor(String type) {
    switch (type.toLowerCase()) {
      case 'xlsx':
      case 'xls':
        return Colors.green.shade700;
      case 'csv':
        return Colors.red.shade700;
      case 'json':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }
}

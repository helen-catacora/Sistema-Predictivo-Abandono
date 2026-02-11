import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/features/importar_datos/presentation/widgets/import_section_header.dart';

import '../../../../core/constants/app_colors.dart';

/// Fila del historial de importaciones.
class ImportHistoryRow {
  const ImportHistoryRow({
    required this.date,
    required this.fileName,
    required this.fileType,
    required this.records,
    required this.success,
    required this.user,
  });

  final String date;
  final String fileName;
  final String fileType; // xlsx, csv, json
  final String records;
  final bool success;
  final String user;
}

/// Tabla de historial de importaciones.
class ImportHistoryTable extends StatelessWidget {
  const ImportHistoryTable({super.key});

  static final _sampleData = [
    ImportHistoryRow(
      date: '15/01/2024 10:32',
      fileName: 'estudiantes_2024.xlsx',
      fileType: 'xlsx',
      records: '1,248',
      success: true,
      user: 'juan.perez@emi.edu.bo',
    ),
    ImportHistoryRow(
      date: '14/01/2024 16:45',
      fileName: 'matricula_sem1.csv',
      fileType: 'csv',
      records: '892',
      success: true,
      user: 'ana.morales@emi.edu.bo',
    ),
    ImportHistoryRow(
      date: '10/01/2024 09:15',
      fileName: 'backup_datos.json',
      fileType: 'json',
      records: '2,104',
      success: false,
      user: 'maria.garcia@emi.edu.bo',
    ),
    ImportHistoryRow(
      date: '05/01/2024 14:20',
      fileName: 'nuevos_estudiantes.xlsx',
      fileType: 'xlsx',
      records: '156',
      success: true,
      user: 'carlos.rojas@emi.edu.bo',
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
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
                                          color: Colors.grey.shade600,
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
      ),
    );
  }

  IconData _fileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'xlsx':
        return Icons.table_chart;
      case 'csv':
        return Icons.description;
      case 'json':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/reporte_historial_item.dart';
import '../providers/reportes_historial_provider.dart';

/// Formatea fecha ISO (ej. 2026-02-08T21:10:03.594Z) a dd/MM/yyyy HH:mm.
String _formatFecha(String isoDate) {
  if (isoDate.isEmpty) return '—';
  try {
    final dt = DateTime.parse(isoDate);
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  } catch (_) {
    return isoDate;
  }
}

/// Color del badge por tipo de reporte.
Color _colorForTipo(String tipo) {
  final t = tipo.toLowerCase();
  if (t.contains('predictivo')) return AppColors.navyMedium;
  if (t.contains('riesgo') || t.contains('estudiantes')) return AppColors.accentYellow;
  if (t.contains('paralelo')) return Colors.purple;
  if (t.contains('asistencia')) return Colors.red;
  if (t.contains('individual')) return Colors.teal;
  return AppColors.grayDark;
}

/// Tabla de reportes generados recientemente (datos de GET /reportes/historial).
class ReportsRecentTable extends StatelessWidget {
  const ReportsRecentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportesHistorialProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoading;
        final hasError = provider.hasError;
        final reportes = provider.reportes;
        final total = provider.total;

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
            if (isLoading && reportes.isEmpty)
              Card(
                elevation: 0,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando historial de reportes...'),
                      ],
                    ),
                  ),
                ),
              )
            else if (hasError && reportes.isEmpty)
              Card(
                elevation: 0,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    provider.errorMessage ?? 'Error al cargar historial',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              )
            else
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
                      rows: reportes.isEmpty
                          ? [
                              DataRow(
                                cells: [
                                  const DataCell(
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24),
                                      child: Text('No hay reportes en el historial'),
                                    ),
                                  ),
                                  ...List.filled(5, const DataCell(SizedBox.shrink())),
                                ],
                              ),
                            ]
                          : reportes.map((r) => _buildRow(r)).toList(),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reportes.isEmpty && !isLoading
                      ? '0 reportes'
                      : 'Mostrando ${reportes.length} de $total reportes',
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
      },
    );
  }

  DataRow _buildRow(ReporteHistorialItem r) {
    final tipoColor = _colorForTipo(r.tipo);
    final tipoLabel = r.tipo.isEmpty ? '—' : r.tipo.toUpperCase();
    final generadoPor = r.generadoPorNombre.isEmpty ? '—' : r.generadoPorNombre;
    final initial = generadoPor != '—' && generadoPor.isNotEmpty ? generadoPor[0] : '?';

    return DataRow(
      cells: [
        DataCell(Text(r.nombre.isEmpty ? '—' : r.nombre)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tipoColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tipoLabel,
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
                  initial.toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(generadoPor),
            ],
          ),
        ),
        DataCell(Text(_formatFecha(r.fechaGeneracion))),
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

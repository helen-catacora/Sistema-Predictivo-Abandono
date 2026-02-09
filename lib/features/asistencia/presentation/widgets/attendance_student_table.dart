import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/asistencias_provider.dart';
import 'attendance_status_selector.dart';

/// Convierte string de API a AttendanceStatus.
AttendanceStatus? _estadoFromString(String s) {
  final t = s.toLowerCase();
  if (t.contains('presente')) return AttendanceStatus.presente;
  if (t.contains('ausente')) return AttendanceStatus.ausente;
  if (t.contains('justificado')) return AttendanceStatus.justificado;
  return null;
}

/// Tabla de estudiantes para registro de asistencia.
class AttendanceStudentTable extends StatelessWidget {
  const AttendanceStudentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AsistenciasProvider>(
      builder: (context, provider, _) {
        if (!provider.hasData && !provider.isLoading) {
          return _buildEmptyState();
        }

        if (provider.hasError) {
          return _buildErrorState(provider.errorMessage ?? 'Error');
        }

        return _buildTable(context, provider);
      },
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: const Padding(
        padding: EdgeInsets.all(48),
        child: Center(
          child: Text(
            'Seleccione paralelo y materia, luego pulse "Aplicar Filtros"',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grayMedium, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, AsistenciasProvider provider) {
    final items = provider.editableAsistencias;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lista de Estudiantes Detallada',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: items.isNotEmpty ? provider.markAllPresent : null,
                  child: const Text('MARCAR TODOS PRESENTES'),
                ),
                TextButton(
                  onPressed: items.isNotEmpty ? provider.clearAll : null,
                  child: const Text('LIMPIAR TODO'),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.gray002855,
                      ),
                      columns: [
                        DataColumn(
                          label: Text(
                            'NRO',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'GRADO',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ESTUDIANTE / CÓDIGO',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'CONTROL DE ASISTENCIA',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'OBSERVACIÓN',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                      rows: items.asMap().entries.map((entry) {
                        final i = entry.key;
                        final e = entry.value;
                        final status = _estadoFromString(e.estado);
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                (i + 1).toString().padLeft(2, '0'),
                                style: GoogleFonts.inter(
                                  color: AppColors.grey94A3B8,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grayLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Estudiante',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBlue1E293B,
                                    height: 16 / 12,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.nombreEstudiante,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black0F172A,
                                      fontSize: 16,
                                      height: 24 / 16,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Text(
                                    e.codigoEstudiante,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.grey64748B,
                                      fontWeight: FontWeight.w400,
                                      height: 16 / 12,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              AttendanceStatusSelector(
                                selectedStatus: status,
                                onChanged: (v) => provider.updateEstatus(i, v),
                              ),
                            ),
                            DataCell(
                              e.observacion.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentYellow
                                            .withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline,
                                            size: 16,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            e.observacion,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chat_bubble_outline,
                                        size: 20,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

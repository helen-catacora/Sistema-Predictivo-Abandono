import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/estudiante_item.dart';
import '../providers/estudiantes_provider.dart';
import 'attendance_bar.dart';
import 'risk_level_indicator.dart';

/// Tabla de estudiantes en riesgo académico.
class StudentTable extends StatelessWidget {
  const StudentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EstudiantesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return _buildLoading(context);
        }
        if (provider.hasError) {
          return _buildError(
            context,
            provider.errorMessage ?? 'Error desconocido',
            provider.loadEstudiantes,
          );
        }
        return _buildTable(context, provider.filteredEstudiantes);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando estudiantes...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
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
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<EstudianteItem> estudiantes) {
    return StudentDataTable(estudiantes: estudiantes);
  }
}

/// Tabla de datos de estudiantes (misma estructura que en EstudiantesPage).
/// Reutilizable para mostrar cualquier lista, p. ej. los primeros 3 en el panel principal.
class StudentDataTable extends StatelessWidget {
  const StudentDataTable({super.key, required this.estudiantes});

  final List<EstudianteItem> estudiantes;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  columnSpacing: 24,
                  dataRowMaxHeight: 65,
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.gray002855,
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        'NOMBRE DEL ESTUDIANTE',
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
                        'ID / MATRÍCULA',
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
                      numeric: false,
                      label: Expanded(
                        child: Text(
                          'ASISTENCIA',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 16 / 12,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      numeric: false,
                      label: Expanded(
                        child: Text(
                          'PROBABILIDAD DE ABANDONO',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 16 / 12,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Text(
                    //     'NIVEL DE RIESGO',
                    //     style: GoogleFonts.inter(
                    //       color: Colors.white,
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w700,
                    //       height: 16 / 12,
                    //       letterSpacing: 0.6,
                    //     ),
                    //   ),
                    // ),
                    DataColumn(
                      label: Text(
                        'CLASIFICACIÓN',
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
                        'ACCIONES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: estudiantes
                      .map(
                        (s) => DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.nombreCompleto,
                                    style: GoogleFonts.inter(
                                      color: AppColors.black0F172A,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Text(
                                    s.carrera,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                s.codigoEstudiante,
                                style: GoogleFonts.inter(
                                  color: AppColors.black0F172A,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: AttendanceBar(
                                  percentage: s.porcentajeAsistencia,
                                ),
                              ),
                            ),
                            DataCell(
                              Builder(
                                builder: (context) {
                                  final double? valorRaw =
                                      s.probabilidadAbandono;
                                  final String porcentaje = valorRaw != null
                                      ? '${(valorRaw * 100).toStringAsFixed(0)}%'
                                      : '-';
                                  final riskLevel = RiskLevel.fromString(
                                    s.nivelRiesgo,
                                  );

                                  return Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 24,
                                      children: [
                                        Text(
                                          porcentaje,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: RiskLevelIndicator.colorFor(
                                              riskLevel,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RiskLevelIndicator(
                                          level: RiskLevel.fromString(
                                            s.nivelRiesgo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // DataCell(
                            //   RiskLevelIndicator(
                            //     level: RiskLevel.fromString(s.nivelRiesgo),
                            //   ),
                            // ),
                            DataCell(
                              Text(
                                s.clasificacion ?? '-',
                                style: GoogleFonts.inter(
                                  color: AppColors.black0F172A,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            DataCell(
                              FilledButton(
                                onPressed: () {
                                  context.push(
                                    AppRoutes.homeEstudiantePerfil(s.id),
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFACC15),
                                  foregroundColor: AppColors.grayDark,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Ver Perfil'),
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
    );
  }
}

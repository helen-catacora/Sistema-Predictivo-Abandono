import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'attendance_bar.dart';
import 'risk_level_indicator.dart';

/// Modelo de estudiante para la tabla.
class StudentRowData {
  const StudentRowData({
    required this.name,
    required this.career,
    required this.id,
    required this.attendance,
    required this.promedio,
    required this.promedioMax,
    required this.riskLevel,
  });

  final String name;
  final String career;
  final String id;
  final int attendance;
  final double promedio;
  final double promedioMax;
  final RiskLevel riskLevel;
}

/// Tabla de estudiantes en riesgo académico.
class StudentTable extends StatelessWidget {
  const StudentTable({super.key});

  static final _sampleData = [
    StudentRowData(
      name: 'Alejandro Morales',
      career: 'Ing. de Sistemas',
      id: 'EMI-2024-0012',
      attendance: 62,
      promedio: 3.2,
      promedioMax: 5.0,
      riskLevel: RiskLevel.alto,
    ),
    StudentRowData(
      name: 'Luciana Beltrán',
      career: 'Ing. Civil',
      id: 'EMI-2024-0085',
      attendance: 81,
      promedio: 3.8,
      promedioMax: 5.0,
      riskLevel: RiskLevel.medio,
    ),
    StudentRowData(
      name: 'Sofía Gutiérrez',
      career: 'Ing. de Sistemas',
      id: 'EMI-2024-0044',
      attendance: 45,
      promedio: 2.1,
      promedioMax: 5.0,
      riskLevel: RiskLevel.alto,
    ),
    StudentRowData(
      name: 'Carlos Rodríguez',
      career: 'Ing. Industrial',
      id: 'EMI-2024-0104',
      attendance: 95,
      promedio: 4.5,
      promedioMax: 5.0,
      riskLevel: RiskLevel.bajo,
    ),
    StudentRowData(
      name: 'Valentina Ruiz',
      career: 'Ing. Mecatrónica',
      id: 'EMI-2024-0099',
      attendance: 75,
      promedio: 3.5,
      promedioMax: 5.0,
      riskLevel: RiskLevel.medio,
    ),
  ];

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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF2C3E50)),
            columns: const [
              DataColumn(
                label: Text(
                  'NOMBRE DEL ESTUDIANTE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ID / MATRÍCULA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  '% ASISTENCIA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'PROMEDIO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'NIVEL DE RIESGO',
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
                .map((s) => DataRow(
                      cells: [
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                s.career,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(s.id)),
                        DataCell(
                          SizedBox(
                            width: 100,
                            child: AttendanceBar(percentage: s.attendance),
                          ),
                        ),
                        DataCell(Text('${s.promedio} / ${s.promedioMax}')),
                        DataCell(RiskLevelIndicator(level: s.riskLevel)),
                        DataCell(
                          FilledButton(
                            onPressed: () {},
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
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

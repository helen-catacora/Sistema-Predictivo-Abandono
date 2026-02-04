import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'attendance_status_selector.dart';

/// Fila de estudiante para la tabla de asistencia.
class StudentAttendanceRowData {
  const StudentAttendanceRowData({
    required this.nro,
    required this.grade,
    required this.name,
    required this.code,
    required this.status,
    this.observation,
  });

  final int nro;
  final String grade; // Est., Alfz., etc.
  final String name;
  final String code;
  final AttendanceStatus? status;
  final String? observation;
}

/// Tabla de estudiantes para registro de asistencia.
class AttendanceStudentTable extends StatefulWidget {
  const AttendanceStudentTable({super.key});

  @override
  State<AttendanceStudentTable> createState() => _AttendanceStudentTableState();
}

class _AttendanceStudentTableState extends State<AttendanceStudentTable> {
  late List<StudentAttendanceRowData> _students;

  @override
  void initState() {
    super.initState();
    _students = [
      StudentAttendanceRowData(
        nro: 1,
        grade: 'Est.',
        name: 'Alex Johnson',
        code: '2023-04921',
        status: AttendanceStatus.presente,
        observation: null,
      ),
      StudentAttendanceRowData(
        nro: 2,
        grade: 'Alfz.',
        name: 'Sarah Williams',
        code: '2023-04875',
        status: AttendanceStatus.ausente,
        observation: null,
      ),
      StudentAttendanceRowData(
        nro: 3,
        grade: 'Est.',
        name: 'Marcus Chen',
        code: '2023-04112',
        status: AttendanceStatus.justificado,
        observation: 'Baja Médica',
      ),
      StudentAttendanceRowData(
        nro: 4,
        grade: 'Est.',
        name: 'María García',
        code: '2023-05234',
        status: AttendanceStatus.presente,
        observation: null,
      ),
      StudentAttendanceRowData(
        nro: 5,
        grade: 'Est.',
        name: 'Carlos López',
        code: '2023-05189',
        status: AttendanceStatus.presente,
        observation: null,
      ),
    ];
  }

  void _markAllPresent() {
    setState(() {
      _students = _students
          .map(
            (s) => StudentAttendanceRowData(
              nro: s.nro,
              grade: s.grade,
              name: s.name,
              code: s.code,
              status: AttendanceStatus.presente,
              observation: s.observation,
            ),
          )
          .toList();
    });
  }

  void _clearAll() {
    setState(() {
      _students = _students
          .map(
            (s) => StudentAttendanceRowData(
              nro: s.nro,
              grade: s.grade,
              name: s.name,
              code: s.code,
              status: null,
              observation: null,
            ),
          )
          .toList();
    });
  }

  void _updateStatus(int index, AttendanceStatus? status) {
    setState(() {
      final s = _students[index];
      _students[index] = StudentAttendanceRowData(
        nro: s.nro,
        grade: s.grade,
        name: s.name,
        code: s.code,
        status: status,
        observation: s.observation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lista de Estudiantes Detallada',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: _markAllPresent,
                  child: const Text('MARCAR TODOS PRESENTES'),
                ),
                TextButton(
                  onPressed: _clearAll,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFF2C3E50),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'NRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'GRADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ESTUDIANTE / CÓDIGO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'CONTROL DE ASISTENCIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'OBSERVACIÓN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: _students.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(s.nro.toString().padLeft(2, '0'))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: s.grade == 'Alfz.'
                                ? AppColors.blueLight
                                : AppColors.grayLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s.grade,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: s.grade == 'Alfz.'
                                  ? AppColors.navyMedium
                                  : AppColors.grayDark,
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
                              s.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              s.code,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        AttendanceStatusSelector(
                          selectedStatus: s.status,
                          onChanged: (v) => _updateStatus(i, v),
                        ),
                      ),
                      DataCell(
                        s.observation != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentYellow.withValues(
                                    alpha: 0.3,
                                  ),
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
                                      s.observation!,
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
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/attendance_filter_section.dart';
import '../widgets/attendance_footer.dart';
import '../widgets/attendance_header.dart';
import '../widgets/attendance_student_table.dart';
import '../widgets/attendance_summary_cards.dart';

/// Pantalla Registro de Asistencia.
class AsistenciaPage extends StatelessWidget {
  const AsistenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AttendanceHeader(),
          const SizedBox(height: 24),
          const AttendanceFilterSection(),
          const SizedBox(height: 24),
          const AttendanceSummaryCards(),
          const SizedBox(height: 24),
          const AttendanceStudentTable(),
          const SizedBox(height: 24),
          const AttendanceFooter(),
        ],
      ),
    );
  }
}

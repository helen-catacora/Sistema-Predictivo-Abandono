import 'package:flutter/material.dart';
import '../widgets/attendance_filter_section.dart';
import '../widgets/attendance_footer.dart';
import '../widgets/attendance_header.dart';
import '../widgets/attendance_student_table.dart';
import '../widgets/attendance_summary_cards.dart';

/// Pantalla Registro de Asistencia.
class AsistenciaPage extends StatefulWidget {
  const AsistenciaPage({super.key});

  @override
  State<AsistenciaPage> createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ParalelosProvider>().loadParalelos();
    //   context.read<MateriasProvider>().loadMaterias();
    // });
  }

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

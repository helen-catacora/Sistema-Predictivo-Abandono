import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

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
          const SizedBox(height: 16),
          const ScreenDescriptionCard(
            description:
                'Registro y consulta de asistencia por paralelo y materia. Visualice resúmenes y registre la asistencia de los estudiantes.',
            icon: Icons.checklist_outlined,
          ),
          const SizedBox(height: 24),
          Text(
              'Seleccionar Curso',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
            ),
          const SizedBox(height: 20),
          const AttendanceFilterSection(),
          const SizedBox(height: 20),
          Text(
              'Resumen de Asistencia',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
            ),
          const SizedBox(height: 20),
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

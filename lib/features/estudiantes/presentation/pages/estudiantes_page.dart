import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';
import '../widgets/academic_risk_header.dart';
import '../widgets/student_filter_section.dart';
import '../widgets/student_summary_cards.dart';
import '../widgets/student_table.dart';

/// Pantalla Estudiantes en Riesgo Académico.
class EstudiantesPage extends StatefulWidget {
  const EstudiantesPage({super.key});

  @override
  State<EstudiantesPage> createState() => _EstudiantesPageState();
}

class _EstudiantesPageState extends State<EstudiantesPage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ParalelosProvider>().loadParalelos();
    //   context.read<EstudiantesProvider>().loadEstudiantes();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AcademicRiskHeader(),
          const SizedBox(height: 16),
          const ScreenDescriptionCard(
            description:
                'Listado y filtrado de estudiantes en riesgo de abandono estudiantil. Permite revisar datos académicos y acceder al perfil detallado de cada estudiante.',
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 24),
          Text(
              'Filtros de Búsqueda',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
          ),
          const SizedBox(height: 20),
          const StudentFilterSection(),
          const SizedBox(height: 24),
          Text(
              'Resumen General',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
          ),
          const SizedBox(height: 20),
          const StudentSummaryCards(),
          const SizedBox(height: 24),
          Text(
              'Listado de Estudiantes',
              style: GoogleFonts.inter(
                color: AppColors.black334155,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
          ),
          const SizedBox(height: 20),
          const StudentTable(),
        ],
      ),
    );
  }
}

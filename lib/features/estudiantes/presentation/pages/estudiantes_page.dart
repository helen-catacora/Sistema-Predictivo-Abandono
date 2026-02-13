import 'package:flutter/material.dart';
import '../widgets/academic_risk_header.dart';
import '../widgets/student_filter_section.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<EstudiantesProvider>().loadEstudiantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AcademicRiskHeader(),
          const SizedBox(height: 24),
          const StudentFilterSection(),
          const SizedBox(height: 24),
          const StudentTable(),
        ],
      ),
    );
  }
}

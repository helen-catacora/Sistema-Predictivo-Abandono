import 'package:flutter/material.dart';

import '../widgets/academic_risk_header.dart';
import '../widgets/student_filter_section.dart';
import '../widgets/student_table.dart';

/// Pantalla Estudiantes en Riesgo Académico.
class EstudiantesPage extends StatelessWidget {
  const EstudiantesPage({super.key});

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

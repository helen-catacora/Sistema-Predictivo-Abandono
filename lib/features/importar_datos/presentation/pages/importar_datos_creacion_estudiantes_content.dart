import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/creacion_estudiantes/creacion_estudiantes_file_selector.dart';
import '../widgets/creacion_estudiantes/creacion_estudiantes_instructions_card.dart';

/// Contenido completo de la pantalla "Importar Datos para Creación de Estudiantes".
class ImportarDatosCreacionEstudiantesPage extends StatelessWidget {
  const ImportarDatosCreacionEstudiantesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildLeftColumn(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Importar Datos para Creación de Estudiantes',
          style: GoogleFonts.inter(
            color: AppColors.gray002855,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 36 / 30,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'CARGUE ARCHIVOS CON INFORMACIÓN PARA REGISTRAR NUEVOS ESTUDIANTES',
          style: GoogleFonts.inter(
            color: AppColors.grey64748B,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CreacionEstudiantesInstructionsCard(),
        const SizedBox(height: 32),
        // const ImportSectionHeader(title: 'Seleccionar Archivo'),
        const SizedBox(height: 16),
        const CreacionEstudiantesFileSelector(),
        // const SizedBox(height: 32),
        // const CreacionEstudiantesHistorialTable(),
      ],
    );
  }
}

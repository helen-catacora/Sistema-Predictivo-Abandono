import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/malla_curricular/malla_curricular_file_selector.dart';
import '../widgets/malla_curricular/malla_curricular_instructions_card.dart';

/// Página para importar malla curricular desde Excel.
/// Usa POST /malla-curricular/importar con multipart/form-data (archivo .xlsx, nombre_malla).
class ImportarDatosMallaCurricularPage extends StatelessWidget {
  const ImportarDatosMallaCurricularPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Importar Malla Curricular',
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
          'CARGUE ARCHIVOS EXCEL CON LA MALLA CURRICULAR (MATERIAS, ÁREAS, SEMESTRES)',
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

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MallaCurricularInstructionsCard(),
        const SizedBox(height: 32),
        const MallaCurricularFileSelector(),
      ],
    );
  }
}

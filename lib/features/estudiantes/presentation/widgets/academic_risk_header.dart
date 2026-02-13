import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/estudiantes/presentation/providers/estudiantes_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de la página Estudiantes en Riesgo Académico.
class AcademicRiskHeader extends StatelessWidget {
  const AcademicRiskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estudiantes en Riesgo Académico',
              style: GoogleFonts.inter(
                color: AppColors.gray002855,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 36 / 30,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monitoreo de indicadores críticos y probabilidad de deserción en Ciencias Básicas.',
              style: GoogleFonts.inter(
                color: AppColors.grey64748B,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        Spacer(),
        RefreshButton(
          onTap: () {
            context.read<EstudiantesProvider>().loadEstudiantes();
          },
        ),
      ],
    );
  }
}

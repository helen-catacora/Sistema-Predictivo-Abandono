import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de la pantalla Gestión de Paralelos.
class ParalelosHeader extends StatelessWidget {
  const ParalelosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestión de Paralelos',
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
          'ADMINISTRACIÓN DE CURSOS Y ASIGNACIÓN DE ENCARGADOS',
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
}

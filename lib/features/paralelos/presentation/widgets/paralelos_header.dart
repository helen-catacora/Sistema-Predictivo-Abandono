import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Encabezado de la pantalla Gestión de Paralelos.
class ParalelosHeader extends StatelessWidget {
  const ParalelosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = Responsive.pageTitleFontSize(constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Paralelos',
              style: GoogleFonts.inter(
                color: AppColors.gray002855,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                height: 36 / 30,
                letterSpacing: 0,
              ),
            ),
          ],
        );
      },
    );
  }
}

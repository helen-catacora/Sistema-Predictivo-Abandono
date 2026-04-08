import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Encabezado principal de la página Importar Datos.
class ImportPageHeader extends StatelessWidget {
  const ImportPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = Responsive.pageTitleFontSize(constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Importar Datos para Predicción de Abandono Estudiantil',
              style: GoogleFonts.inter(
                color: AppColors.gray002855,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                height: 36 / 30,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            const ScreenDescriptionCard(
              description:
                  'Cargue archivos Excel con información estudiantil para el registro de estudiantes en el sistema.',
              icon: Icons.file_download_outlined,
            ),
          ],
        );
      },
    );
  }
}

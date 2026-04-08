import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/materias_provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/paralelos_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Encabezado de la página Registro de Asistencia.
class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = Responsive.isMobile(w);
        final fontSize = Responsive.pageTitleFontSize(w);

        final titleText = Text(
          'REGISTRO DE ASISTENCIA',
          style: GoogleFonts.inter(
            color: AppColors.navyMedium,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            height: 36 / 30,
            letterSpacing: 0,
          ),
        );

        final refreshButton = RefreshButton(
          onTap: () {
            context.read<ParalelosProvider>().loadParalelos();
            context.read<MateriasProvider>().loadMaterias();
          },
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: refreshButton),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleText,
            refreshButton,
          ],
        );
      },
    );
  }
}

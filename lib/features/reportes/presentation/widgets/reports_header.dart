import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_historial_provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_tipos_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Encabezado del Centro de Reportes.
class ReportsHeader extends StatelessWidget {
  final String title;
  const ReportsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = Responsive.isMobile(w);
        final fontSize = Responsive.pageTitleFontSize(w);

        final titleText = Text(
          title,
          style: GoogleFonts.inter(
            color: AppColors.gray002855,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 36 / 30,
            letterSpacing: 0,
          ),
        );

        final refreshButton = RefreshButton(
          onTap: () {
            context.read<ReportesTiposProvider>().loadTipos();
            context.read<ReportesHistorialProvider>().loadHistorial(
              page: 1,
              pageSize: 20,
            );
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
          children: [
            titleText,
            const Spacer(),
            refreshButton,
          ],
        );
      },
    );
  }
}

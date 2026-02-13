import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_historial_provider.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/providers/reportes_tipos_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado del Centro de Reportes.
class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Centro de Reportes',
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
              'ANÁLISIS INTEGRAL DE DESERCIÓN ESTUDIANTIL - GESTIÓN ${DateTime.now().year}',
              style: GoogleFonts.inter(
                color: AppColors.grey64748B,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        Spacer(),
        RefreshButton(
          onTap: () {
            context.read<ReportesTiposProvider>().loadTipos();
            context.read<ReportesHistorialProvider>().loadHistorial(
              page: 1,
              pageSize: 20,
            );
          },
        ),
      ],
    );
  }
}

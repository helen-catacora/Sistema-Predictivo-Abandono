import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/materias_provider.dart';
import 'package:sistemapredictivoabandono/features/asistencia/presentation/providers/paralelos_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de la página Registro de Asistencia.
class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMI Ciencias Básicas > Control de Asistencia',
          style: GoogleFonts.inter(
            color: AppColors.grey64748B,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REGISTRO DE ASISTENCIA',
              style: GoogleFonts.inter(
                color: AppColors.navyMedium,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 36 / 30,
                letterSpacing: 0,
              ),
            ),
            Spacer(),
            RefreshButton(
              onTap: () {
                context.read<ParalelosProvider>().loadParalelos();
                context.read<MateriasProvider>().loadMaterias();
              },
            ),
            // Row(
            // children: [
            //   OutlinedButton.icon(
            //     onPressed: () {},
            //     icon: const Icon(Icons.download, size: 18),
            //     label: const Text('Exportar'),
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: AppColors.navyMedium,
            //     ),
            //   ),
            //   const SizedBox(width: 12),
            //   FilledButton.icon(
            //     onPressed: () {},
            //     icon: const Icon(Icons.save, size: 18),
            //     label: const Text('Guardar Registro'),
            //     style: FilledButton.styleFrom(
            //       backgroundColor: AppColors.navyMedium,
            //     ),
            //   ),
            // ],
            // ),
          ],
        ),
      ],
    );
  }
}

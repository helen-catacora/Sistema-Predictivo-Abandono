import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/estudiantes_provider.dart';

/// Tarjetas de resumen: total de estudiantes y cantidad de abandono.
class StudentSummaryCards extends StatelessWidget {
  const StudentSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EstudiantesProvider>(
      builder: (context, provider, _) {
        final list = provider.filteredEstudiantes;
        final total = list.length;
        final abandono = list
            .where((e) => e.clasificacion == 'Abandona')
            .length;

        return Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'TOTAL DE ESTUDIANTES',
                value: total.toString(),
                valueColor: AppColors.darkBlue1E293B,
                borderColor: const Color(0xff002855),
                backGroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'CANTIDAD DE ABANDONO',
                value: abandono.toString(),
                valueColor: const Color(0xFFEF4444),
                borderColor: AppColors.redDC2626,
                backGroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.borderColor,
    this.backGroundColor = Colors.white,
  });

  final String title;
  final String value;
  final Color valueColor;
  final Color borderColor;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.grey94A3B8,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 36 / 30,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

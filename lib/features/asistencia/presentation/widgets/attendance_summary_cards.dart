import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/asistencias_provider.dart';

/// Tarjetas de resumen de asistencia.
class AttendanceSummaryCards extends StatelessWidget {
  const AttendanceSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AsistenciasProvider>(
      builder: (context, provider, _) {
        final hasData = provider.hasData;
        return Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'TOTAL ESTUDIANTES',
                value: hasData ? provider.totalEstudiantes.toString() : '-',
                valueColor: AppColors.darkBlue1E293B,
                borderColor: Color(0xff002855),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'PRESENTES',
                value: hasData ? provider.totalPresentes.toString() : '-',
                valueColor: const Color(0xFF22C55E),
                borderColor: AppColors.green16A34A,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'AUSENTES',
                value: hasData ? provider.totalAusentes.toString() : '-',
                valueColor: const Color(0xFFEF4444),
                borderColor: AppColors.redDC2626,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'TASA DE ASISTENCIA',
                value: hasData
                    ? '${provider.porcentajeAsistenciaDia.toStringAsFixed(1)}%'
                    : '-',
                valueColor: AppColors.navyMedium,
                borderColor: AppColors.gray002855,
                backGroundColor: Color(0xffFEFCE8).withValues(alpha: 0.5),
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
            offset: Offset(0, 1),
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

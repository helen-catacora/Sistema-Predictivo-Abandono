import 'package:flutter/material.dart';
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
                value: hasData
                    ? provider.totalEstudiantes.toString()
                    : '-',
                valueColor: AppColors.navyMedium,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'PRESENTES',
                value: hasData ? provider.totalPresentes.toString() : '-',
                valueColor: const Color(0xFF22C55E),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: 'AUSENTES',
                value: hasData ? provider.totalAusentes.toString() : '-',
                valueColor: const Color(0xFFEF4444),
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
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

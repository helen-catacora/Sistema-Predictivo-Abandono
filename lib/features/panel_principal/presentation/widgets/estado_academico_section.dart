import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'metric_card.dart';

/// Sección Estado Académico con tarjetas de métricas.
class EstadoAcademicoSection extends StatelessWidget {
  const EstadoAcademicoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado Académico',
          style: TextStyle(
            color: AppColors.navyMedium,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'SISTEMA DE ALERTA TEMPRANA DE DESERCIÓN ESCOLAR (SAT-DE)',
          style: TextStyle(
            color: AppColors.grayMedium,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                SizedBox(
                  width: _cardWidth(constraints.maxWidth),
                  child: MetricCard(
                    title: 'ESTUDIANTES EN RIESGO ALTO',
                    value: '42',
                    subtitle: '3.4% del total de inscritos',
                    trend: '+5.2%',
                    trendIsPositive: true,
                    icon: Icons.people_outline,
                  ),
                ),
                SizedBox(
                  width: _cardWidth(constraints.maxWidth),
                  child: MetricCard(
                    title: 'POBLACIÓN TOTAL',
                    value: '1,248',
                    badge: 'ACTIVOS',
                    details: [
                      'VARONES 65%',
                      'MUJERES 35%',
                      'BECADOS 12%',
                    ],
                    icon: Icons.school_outlined,
                  ),
                ),
                SizedBox(
                  width: _cardWidth(constraints.maxWidth),
                  child: _PlaceholderMetricCard(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  static double _cardWidth(double maxWidth) {
    if (maxWidth > 1200) return 280;
    if (maxWidth > 900) return 240;
    return double.infinity;
  }
}

class _PlaceholderMetricCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: SizedBox(
        height: 140,
        child: Center(
          child: Icon(
            Icons.school_outlined,
            size: 48,
            color: AppColors.grayLight,
          ),
        ),
      ),
    );
  }
}

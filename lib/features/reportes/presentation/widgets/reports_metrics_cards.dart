import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tarjetas de métricas del centro de reportes.
class ReportsMetricsCards extends StatelessWidget {
  const ReportsMetricsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            badge: 'TOTAL',
            badgeColor: AppColors.navyMedium,
            icon: Icons.description_outlined,
            value: '247',
            description: 'Reportes Generados',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            badge: 'RECIENTE',
            badgeColor: AppColors.accentYellow,
            icon: Icons.access_time,
            value: '18',
            description: 'Esta Semana',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            badge: 'ACTIVO',
            badgeColor: const Color(0xFF22C55E),
            icon: Icons.download,
            value: '1,842',
            description: 'Descargas Totales',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            badge: 'URGENTE',
            badgeColor: const Color(0xFFEF4444),
            icon: Icons.warning_amber_rounded,
            value: '12',
            description: 'Alertas Críticas',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.value,
    required this.description,
  });

  final String badge;
  final Color badgeColor;
  final IconData icon;
  final String value;
  final String description;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: badgeColor, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

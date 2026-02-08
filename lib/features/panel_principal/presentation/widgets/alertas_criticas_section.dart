import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección Alertas Críticas.
class AlertasCriticasSection extends StatelessWidget {
  const AlertasCriticasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.accentYellow,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Alertas Críticas',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AlertItem(
            name: 'Juan Pérez',
            detail: 'Inasistencia: 28%',
            detailColor: AppColors.grayMedium,
            badge: 'ALTO',
            badgeColor: Colors.orange,
            badgeTextColor: AppColors.white,
            initial: 'J',
          ),
          const SizedBox(height: 12),
          _AlertItem(
            name: 'Maria Gomez',
            detail: 'Promedio: 51/100',
            detailColor: Colors.red.shade300,
            badge: 'CRÍTICO',
            badgeColor: Colors.red,
            badgeTextColor: AppColors.white,
            initial: 'M',
          ),
          const SizedBox(height: 12),
          _AlertItem(
            name: 'Carlos Ruiz',
            detail: 'Materias Reprobadas: 3',
            detailColor: AppColors.accentYellow,
            badge: 'ALTO',
            badgeColor: Colors.orange,
            badgeTextColor: AppColors.white,
            initial: 'C',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.grayDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.folder_outlined, size: 20),
              label: const Text(
                'PROTOCOLO DE INTERVENCIÓN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({
    required this.name,
    required this.detail,
    required this.detailColor,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    this.initial,
  });

  final String name;
  final String detail;
  final Color detailColor;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    final letter = initial ?? (name.isNotEmpty ? name[0] : '?');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navyDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.navyDark,
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(
                    color: detailColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

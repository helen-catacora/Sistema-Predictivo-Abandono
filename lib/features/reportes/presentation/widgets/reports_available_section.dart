import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección de reportes disponibles.
class ReportsAvailableSection extends StatelessWidget {
  const ReportsAvailableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Reportes Disponibles',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('NUEVO REPORTE'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _ReportTemplateCard(
              icon: Icons.show_chart,
              title: 'Análisis Predictivo General',
              description: 'Resumen de predicciones y tendencias de deserción',
              updated: 'Hoy',
            ),
            _ReportTemplateCard(
              icon: Icons.people_outline,
              title: 'Estudiantes en Riesgo',
              description: 'Listado detallado de estudiantes con alertas',
              updated: 'Hoy',
            ),
            _ReportTemplateCard(
              icon: Icons.description_outlined,
              title: 'Reporte por Carrera',
              description: 'Análisis desglosado por programa académico',
              updated: 'Ayer',
            ),
            _ReportTemplateCard(
              icon: Icons.schedule,
              title: 'Seguimiento de Casos',
              description: 'Estado de intervenciones y seguimientos',
              updated: 'Ayer',
            ),
            _ReportTemplateCard(
              icon: Icons.emoji_events_outlined,
              title: 'Rendimiento Académico',
              description: 'Métricas de desempeño por cohorte',
              updated: 'Hace 2 días',
            ),
            _ReportTemplateCard(
              icon: Icons.calendar_month,
              title: 'Asistencia por Período',
              description: 'Resumen de asistencia por materia y fecha',
              updated: 'Hace 2 días',
            ),
          ],
        ),
      ],
    );
  }
}

class _ReportTemplateCard extends StatelessWidget {
  const _ReportTemplateCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.updated,
  });

  final IconData icon;
  final String title;
  final String description;
  final String updated;

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
              children: [
                Icon(icon, color: AppColors.navyMedium, size: 28),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ACTIVO',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actualizado: $updated',
                  style: TextStyle(
                    color: AppColors.grayMedium,
                    fontSize: 11,
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('GENERAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/dashboard_provider.dart';
import 'metric_card.dart';

/// Sección Estado Académico con tarjetas de métricas (datos de resumen_general).
class EstadoAcademicoSection extends StatelessWidget {
  const EstadoAcademicoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final r = dashboard.resumenGeneral;
        final isLoading = dashboard.isLoading;
        final hasError = dashboard.hasError;

        final totalAlto = r?.totalAltoRiesgo ?? 0;
        final totalEst = r?.totalEstudiantes ?? 0;
        final pctAlto = r?.porcentajeAltoRiesgo ?? 0.0;
        final alertasActivas = r?.totalAlertasActivas ?? 0;
        final alertasCriticas = r?.totalAlertasCriticas ?? 0;
        final altoRiesgo = r?.totalAltoRiesgo ?? 0;
        final medioRiesgo = r?.totalMedioRiesgo ?? 0;

        String valueOrPlaceholder(int v) =>
            isLoading && !hasError ? '—' : v.toString();
        String valueOrPlaceholderFormatted(int v) =>
            isLoading && !hasError ? '—' : _formatNumber(v);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado Académico - Gestión 2024',
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
            if (hasError) ...[
              const SizedBox(height: 12),
              Text(
                dashboard.errorMessage ?? 'Error al cargar',
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            ],
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
                        value: valueOrPlaceholder(totalAlto),
                        subtitle: totalEst > 0
                            ? '${pctAlto.toStringAsFixed(1)}% del total de inscritos'
                            : (isLoading && !hasError ? '—' : '0% del total'),
                        trend: totalAlto > 0 ? null : null,
                        trendIsPositive: true,
                        topBorderColor: Colors.red,
                        icon: Icons.warning_amber_rounded,
                      ),
                    ),
                    SizedBox(
                      width: _cardWidth(constraints.maxWidth),
                      child: MetricCard(
                        title: 'POBLACIÓN TOTAL',
                        value: valueOrPlaceholderFormatted(totalEst),
                        badge: 'ACTIVOS',
                        details: r != null && totalEst > 0
                            ? [
                                'Predicciones activas: ${r.totalPrediccionesActivas}',
                                'Bajo riesgo: ${r.totalBajoRiesgo}',
                                'Medio riesgo: ${r.totalMedioRiesgo}',
                              ]
                            : null,
                        icon: Icons.school_outlined,
                      ),
                    ),
                    SizedBox(
                      width: _cardWidth(constraints.maxWidth),
                      child: MetricCard(
                        title: 'ALERTAS ACTIVAS',
                        value: valueOrPlaceholder(alertasActivas),
                        trend: alertasCriticas > 0 ? null : null,
                        trendIsPositive: true,
                        trendColor: AppColors.accentYellow,
                        topBorderColor: AppColors.accentYellow,
                        details: alertasActivas > 0
                            ? [
                                'Críticas: $alertasCriticas',
                                'Altas: $altoRiesgo',
                                'Medias: $medioRiesgo',
                              ]
                            : null,
                        detailColors: alertasActivas > 0
                            ? [
                                Colors.red,
                                Colors.orange,
                                AppColors.accentYellow,
                              ]
                            : null,
                        icon: Icons.notifications_active_outlined,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  static String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  static double _cardWidth(double maxWidth) {
    if (maxWidth > 1200) return 280;
    if (maxWidth > 900) return 240;
    return double.infinity;
  }
}

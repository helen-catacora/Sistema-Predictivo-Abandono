import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              'SISTEMA DE ALERTA TEMPRANA DE ABANDONO ESTUDIANTIL (EMI)',
              style: GoogleFonts.inter(
                color: AppColors.grey64748B,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: 0.7,
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
                return Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: 'ESTUDIANTES EN RIESGO ALTO',
                        value: valueOrPlaceholder(totalAlto),
                        subtitle: totalEst > 0
                            ? '${pctAlto.toStringAsFixed(1)}% del total de inscritos'
                            : (isLoading && !hasError ? '—' : '0% del total'),
                        trend: totalAlto > 0 ? null : null,
                        trendIsPositive: true,
                        topBorderColor: Colors.red,
                        iconPath: 'assets/riesgo.png',
                      ),
                    ),
                    Expanded(
                      child: MetricCard(
                        title: 'POBLACIÓN TOTAL',
                        value: valueOrPlaceholderFormatted(totalEst),
                        badge: 'ACTIVOS',
                        detailsTitles: r != null && totalEst > 0
                            ? [
                                'Predicciones activas',
                                'Bajo riesgo',
                                'Medio riesgo',
                              ]
                            : null,
                        detailsContent: r != null && totalEst > 0
                            ? [
                                '${r.totalPrediccionesActivas}',
                                '${r.totalBajoRiesgo}',
                                '${r.totalMedioRiesgo}',
                              ]
                            : null,
                        topBorderColor: Colors.black,
                        iconPath: 'assets/poblacion.png',
                      ),
                    ),
                    Expanded(
                      child: MetricCard(
                        title: 'ALERTAS ACTIVAS',
                        value: valueOrPlaceholder(alertasActivas),
                        trend: alertasCriticas > 0 ? null : null,
                        trendIsPositive: true,
                        trendColor: AppColors.accentYellow,
                        topBorderColor: AppColors.accentYellow,
                        showAsColumn: false,
                        detailsContent: alertasActivas > 0
                            ? [
                                '$alertasCriticas',
                                '$altoRiesgo',
                                '$medioRiesgo',
                              ]
                            : null,
                        detailsTitles: alertasActivas > 0
                            ? ['Críticas:', 'Altas:', 'Medias:']
                            : null,
                        detailColors: alertasActivas > 0
                            ? [
                                Color(0xffDC2626),
                                Color(0xffCA8A04),
                                Color(0xff2563EB),
                              ]
                            : null,
                        iconPath: 'assets/alertas.png',
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
}

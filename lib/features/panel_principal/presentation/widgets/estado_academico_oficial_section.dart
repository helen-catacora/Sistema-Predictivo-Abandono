import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

const _ordenNiveles = ['Bajo', 'Medio', 'Alto', 'Critico'];
const _coloresNivel = [
  Color(0xff44AD74),
  Color(0xff4674F5),
  Color(0xffE79914),
  Color(0xffC63627),
];

/// Variante "Oficial" de la sección Estado Académico con donuts integrados en cada tarjeta.
class EstadoAcademicoOficialSection extends StatelessWidget {
  const EstadoAcademicoOficialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final r = dashboard.resumenGeneral;
        final dist = dashboard.distribucionRiesgo;
        final isLoading = dashboard.isLoading;
        final hasError = dashboard.hasError;

        final totalAlto = r?.totalAltoRiesgo ?? 0;
        final totalEst = r?.totalEstudiantes ?? 0;
        final pctAlto = r?.porcentajeAltoRiesgo ?? 0.0;
        final alertasActivas = r?.totalAlertasActivas ?? 0;
        final alertasCriticas = r?.totalAlertasCriticas ?? 0;
        final altoRiesgo = r?.totalAltoRiesgo ?? 0;
        final medioRiesgo = r?.totalMedioRiesgo ?? 0;

        String val(int v) => (isLoading && !hasError) ? '—' : v.toString();

        // ── Secciones para Card 1: Riesgo Alto ──────────────────────────────
        List<PieChartSectionData> seccionesRiesgo() {
          final pResto = 100.0 - pctAlto;
          if (pctAlto == 0 && pResto == 0) {
            return [_seccionPlaceholder()];
          }
          return [
            PieChartSectionData(
              value: pctAlto > 0 ? pctAlto : 0.0,
              color: const Color(0xffC63627),
              radius: 22,
              showTitle: false,
            ),
            PieChartSectionData(
              value: pResto > 0 ? pResto : 100.0,
              color: const Color(0xffE5E7EB),
              radius: 22,
              showTitle: false,
            ),
          ];
        }

        // ── Secciones para Card 2: Población Total ──────────────────────────
        List<PieChartSectionData> seccionesPoblacion() {
          if (dist.isEmpty || dist.every((e) => e.cantidad == 0)) {
            return [_seccionPlaceholder()];
          }
          final secciones = <PieChartSectionData>[];
          for (var i = 0; i < _ordenNiveles.length; i++) {
            final nivel = _ordenNiveles[i];
            DistribucionRiesgoItem? item;
            try {
              item = dist.firstWhere((e) => e.nivel == nivel);
            } catch (_) {
              item = null;
            }
            final cantidad = item?.cantidad ?? 0;
            if (cantidad > 0) {
              secciones.add(PieChartSectionData(
                value: cantidad.toDouble(),
                color: _coloresNivel[i],
                radius: 22,
                showTitle: false,
              ));
            }
          }
          return secciones.isEmpty ? [_seccionPlaceholder()] : secciones;
        }

        // ── Secciones para Card 3: Alertas ──────────────────────────────────
        List<PieChartSectionData> seccionesAlertas() {
          if (alertasCriticas == 0 && altoRiesgo == 0 && medioRiesgo == 0) {
            return [_seccionPlaceholder()];
          }
          final secciones = <PieChartSectionData>[];
          if (alertasCriticas > 0) {
            secciones.add(PieChartSectionData(
              value: alertasCriticas.toDouble(),
              color: const Color(0xffDC2626),
              radius: 22,
              showTitle: false,
            ));
          }
          if (altoRiesgo > 0) {
            secciones.add(PieChartSectionData(
              value: altoRiesgo.toDouble(),
              color: const Color(0xffCA8A04),
              radius: 22,
              showTitle: false,
            ));
          }
          if (medioRiesgo > 0) {
            secciones.add(PieChartSectionData(
              value: medioRiesgo.toDouble(),
              color: const Color(0xff2563EB),
              radius: 22,
              showTitle: false,
            ));
          }
          return secciones.isEmpty ? [_seccionPlaceholder()] : secciones;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Estado Académico de los Estudiantes',
              style: GoogleFonts.inter(
                color: AppColors.gray002855,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                height: 36 / 30,
                letterSpacing: 0,
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
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _DonutMetricCard(
                      title: 'ESTUDIANTES EN RIESGO ALTO',
                      value: val(totalAlto),
                      subtitle: totalEst > 0
                          ? '${pctAlto.toStringAsFixed(1)}% del total de inscritos'
                          : (isLoading && !hasError ? '—' : '0% del total'),
                      sections: seccionesRiesgo(),
                      centerLabel:
                          '${pctAlto.toStringAsFixed(0)}%',
                      topBorderColor: Colors.red,
                      leyenda: const [
                        _LegendItem(Color(0xffC63627), 'Riesgo alto'),
                        _LegendItem(Color(0xffE5E7EB), 'Resto'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _DonutMetricCard(
                      title: 'POBLACIÓN TOTAL',
                      value: totalEst >= 1000
                          ? '${(totalEst / 1000).toStringAsFixed(1)}k'
                          : val(totalEst),
                      subtitle: 'Estudiantes activos',
                      sections: seccionesPoblacion(),
                      centerLabel: val(totalEst),
                      topBorderColor: Colors.black,
                      leyenda: const [
                        _LegendItem(Color(0xff44AD74), 'Bajo'),
                        _LegendItem(Color(0xff4674F5), 'Medio'),
                        _LegendItem(Color(0xffE79914), 'Alto'),
                        _LegendItem(Color(0xffC63627), 'Crítico'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _DonutMetricCard(
                      title: 'ALERTAS ACTIVAS',
                      value: val(alertasActivas),
                      subtitle: 'Alertas generadas',
                      sections: seccionesAlertas(),
                      centerLabel: val(alertasActivas),
                      topBorderColor: AppColors.accentYellow,
                      leyenda: const [
                        _LegendItem(Color(0xffDC2626), 'Críticas'),
                        _LegendItem(Color(0xffCA8A04), 'Altas'),
                        _LegendItem(Color(0xff2563EB), 'Medias'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static PieChartSectionData _seccionPlaceholder() => PieChartSectionData(
        value: 1,
        color: const Color(0xffE5E7EB),
        radius: 22,
        showTitle: false,
      );
}

// ── Tarjeta de métrica con donut ─────────────────────────────────────────────

class _DonutMetricCard extends StatelessWidget {
  const _DonutMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.sections,
    required this.centerLabel,
    required this.topBorderColor,
    required this.leyenda,
  });

  final String title;
  final String value;
  final String subtitle;
  final List<PieChartSectionData> sections;
  final String centerLabel;
  final Color topBorderColor;
  final List<_LegendItem> leyenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: topBorderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda: título, valor, subtítulo, leyenda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.grey64748B,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: AppColors.darkBlue1E293B,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: AppColors.grey94A3B8,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: leyenda
                        .map((l) => _LegendChip(color: l.color, label: l.label))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Donut chart
            SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      centerSpaceRadius: 35,
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(enabled: false),
                      sections: sections,
                    ),
                  ),
                  Text(
                    centerLabel,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue1E293B,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Leyenda ──────────────────────────────────────────────────────────────────

class _LegendItem {
  const _LegendItem(this.color, this.label);
  final Color color;
  final String label;
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.grey64748B,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

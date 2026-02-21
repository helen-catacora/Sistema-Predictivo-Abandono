import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

/// Orden y color por nivel de riesgo (igual que el backend).
const _ordenNiveles = ['Bajo', 'Medio', 'Alto', 'Critico'];
const _coloresNivel = [
  Color(0xff44AD74),
  Color(0xff4674F5),
  Color(0xffE79914),
  Color(0xffC63627),
];

/// Label para mostrar (Critico → Crítico).
String _labelNivel(String nivel) {
  if (nivel == 'Critico') return 'Crítico';
  return nivel;
}

/// Sección Distribución de Riesgo por Nivel con gráfico de barras (datos de distribucion_riesgo).
class TendenciaHistoricaSection extends StatefulWidget {
  const TendenciaHistoricaSection({super.key});

  @override
  State<TendenciaHistoricaSection> createState() =>
      _TendenciaHistoricaSectionState();
}

class _TendenciaHistoricaSectionState extends State<TendenciaHistoricaSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final dist = dashboard.distribucionRiesgo;
        final isLoading = dashboard.isLoading;
        final hasError = dashboard.hasError;

        // Construir barras en orden Bajo, Medio, Alto, Crítico (como en el API).
        final barItems = <_BarItem>[];
        if (dist.isNotEmpty) {
          for (var i = 0; i < _ordenNiveles.length; i++) {
            final nivel = _ordenNiveles[i];
            DistribucionRiesgoItem? item;
            try {
              item = dist.firstWhere((e) => e.nivel == nivel);
            } catch (_) {
              item = null;
            }
            barItems.add(
              _BarItem(
                _labelNivel(nivel),
                item != null ? item.cantidad.toDouble() : 0.0,
                _coloresNivel[i],
              ),
            );
          }
        } else if (!isLoading && !hasError) {
          barItems.addAll([
            _BarItem('Bajo', 0, Colors.green),
            _BarItem('Medio', 0, Colors.blue),
            _BarItem('Alto', 0, Colors.orange),
            _BarItem('Crítico', 0, Colors.red),
          ]);
        } else {
          barItems.addAll([
            _BarItem('Bajo', 0, Colors.green),
            _BarItem('Medio', 0, Colors.blue),
            _BarItem('Alto', 0, Colors.orange),
            _BarItem('Crítico', 0, Colors.red),
          ]);
        }

        final maxCantidad = barItems.isEmpty
            ? 10.0
            : barItems.map((e) => e.value).reduce((a, b) => a > b ? a : b);
        final maxY = (maxCantidad * 1.2).clamp(10.0, double.infinity);
        final interval = maxY <= 20 ? 5.0 : (maxY / 5).ceilToDouble();

        return SizedBox(
          height: double.infinity,
          child: Card(
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
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.navyMedium,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Gráfico de barras',
                            style: TextStyle(
                              color: AppColors.navyMedium,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isLoading && barItems.every((e) => e.value == 0))
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 260,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          barTouchData: BarTouchData(
                            enabled: false,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) =>
                                  Colors.transparent, // Fondo transparente
                              tooltipPadding: EdgeInsets.zero,
                              tooltipMargin: 3,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toInt().toString(),
                                      TextStyle(
                                        color: AppColors
                                            .darkBlue1E293B, // Color del texto
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  if (i >= 0 && i < barItems.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        barItems[i].label,
                                        style: TextStyle(
                                          color: AppColors.grayDark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                reservedSize: 28,
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Número de Estudiantes',
                                style: TextStyle(
                                  color: AppColors.grayMedium,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: AppColors.grayMedium,
                                      fontSize: 11,
                                    ),
                                  );
                                },
                                reservedSize: 32,
                                interval: interval,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: interval,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: barItems.asMap().entries.map((e) {
                            final i = e.key;
                            final item = e.value;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: item.value,
                                  color: item.color,
                                  width: 150,
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(0),
                                  ),
                                ),
                              ],
                              showingTooltipIndicators: [0],
                            );
                          }).toList(),
                        ),
                        duration: const Duration(milliseconds: 250),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Nivel de Riesgo',
                        style: TextStyle(
                          color: AppColors.grayMedium,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarItem {
  const _BarItem(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

/// Orden y color por nivel de riesgo (igual que el backend).
const _ordenNiveles = ['Bajo', 'Medio', 'Alto', 'Critico'];
const _coloresNivel = [
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.red,
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
  bool _porNivel = true;

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
            barItems.add(_BarItem(
              _labelNivel(nivel),
              item != null ? item.cantidad.toDouble() : 0.0,
              _coloresNivel[i],
            ));
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
                          'Distribución de Riesgo por Nivel',
                          style: TextStyle(
                            color: AppColors.navyMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _TabButton(
                          label: 'POR NIVEL',
                          isSelected: _porNivel,
                          onTap: () => setState(() => _porNivel = true),
                        ),
                        const SizedBox(width: 8),
                        _TabButton(
                          label: 'POR CARRERA',
                          isSelected: !_porNivel,
                          onTap: () => setState(() => _porNivel = false),
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
                else
                  ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 260,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          barTouchData: BarTouchData(enabled: false),
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
                                  width: 36,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ],
                              showingTooltipIndicators: [],
                            );
                          }).toList(),
                        ),
                        duration: const Duration(milliseconds: 250),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Número de Estudiantes',
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navyDark : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.grayMedium,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grayDark,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

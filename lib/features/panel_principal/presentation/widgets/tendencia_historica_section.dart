import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_colors.dart';

/// Datos para una barra del gráfico de distribución de riesgo.
class _BarItem {
  const _BarItem(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

/// Sección Distribución de Riesgo por Nivel con gráfico de barras.
class TendenciaHistoricaSection extends StatefulWidget {
  const TendenciaHistoricaSection({super.key});

  @override
  State<TendenciaHistoricaSection> createState() =>
      _TendenciaHistoricaSectionState();
}

class _TendenciaHistoricaSectionState extends State<TendenciaHistoricaSection> {
  bool _porNivel = true;

  static const _barData = [
    _BarItem('Bajo', 320, Colors.green),
    _BarItem('Medio', 185, Colors.blue),
    _BarItem('Alto', 95, Colors.orange),
    _BarItem('Crítico', 42, Colors.red),
  ];

  static const _maxY = 350.0;

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
            const SizedBox(height: 24),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _maxY,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i >= 0 && i < _barData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _barData[i].label,
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
                        interval: 100,
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
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _barData.asMap().entries.map((e) {
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
        ),
      ),
    );
  }
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

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección de gráficos: Distribución de Riesgo y Causas de Deserción.
class ReportsChartsSection extends StatelessWidget {
  const ReportsChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _ChartCard(
            title: 'Distribución de Riesgo por Semestre',
            onExport: () {},
            child: SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 40,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          'Sem ${value.toInt()}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
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
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeBarGroup(0, 12, 18, 8),
                    _makeBarGroup(1, 10, 15, 12),
                    _makeBarGroup(2, 14, 12, 10),
                    _makeBarGroup(3, 8, 20, 14),
                    _makeBarGroup(4, 15, 10, 12),
                    _makeBarGroup(5, 11, 16, 9),
                  ],
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ChartCard(
            title: 'Causas de Deserción',
            child: SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: 35,
                      color: AppColors.navyMedium,
                      title: '35%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: AppColors.accentYellow,
                      title: '25%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    PieChartSectionData(
                      value: 22,
                      color: const Color(0xFFEF4444),
                      title: '22%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 18,
                      color: Colors.grey.shade400,
                      title: '18%',
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

BarChartGroupData _makeBarGroup(int x, double r, double a, double b) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: r,
        color: const Color(0xFFEF4444),
        width: 10,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      BarChartRodData(
        toY: a,
        color: AppColors.accentYellow,
        width: 10,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      BarChartRodData(
        toY: b,
        color: AppColors.navyMedium,
        width: 10,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    ],
    barsSpace: 4,
  );
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.child,
    this.onExport,
  });

  final String title;
  final Widget child;
  final VoidCallback? onExport;

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
                      title,
                      style: TextStyle(
                        color: AppColors.navyMedium,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (onExport != null)
                  TextButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('EXPORTAR'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.navyMedium,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

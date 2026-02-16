import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/estudiante_perfil_response.dart';
import 'perfil_section_card.dart';

/// Sección Análisis de Riesgo - ML: probabilidad, historial, gráfico y factores.
class PerfilRiesgoMlSection extends StatelessWidget {
  const PerfilRiesgoMlSection({
    super.key,
    this.riesgoYPrediccion,
    required this.probabilidadPorcentaje,
  });

  final RiesgoYPrediccionPerfil? riesgoYPrediccion;
  final double probabilidadPorcentaje;

  @override
  Widget build(BuildContext context) {
    final pred = riesgoYPrediccion?.prediccionActual;
    final historial = riesgoYPrediccion?.historial ?? [];
    final features = pred?.featuresUtilizadas ?? {};

    return PerfilSectionCard(
      icon: Icons.show_chart,
      title: 'Análisis de Riesgo - Machine Learning',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROBABILIDAD DE ABANDONO',
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${probabilidadPorcentaje.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (probabilidadPorcentaje / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade700),
                    ),
                  ),
                  if (pred?.fechaPrediccion != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Última Actualización ${_formatDate(pred!.fechaPrediccion!)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // const Text(
            //   'CLASIFICACIÓN HISTÓRICA',
            //   style: TextStyle(
            //     color: AppColors.navyMedium,
            //     fontSize: 12,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     _historialChip('Semestre Actual', pred?.nivelRiesgo ?? '-'),
            //     const SizedBox(width: 12),
            //     _historialChip(
            //       'Semestre Anterior',
            //       historial.length >= 2
            //           ? (historial[historial.length - 2].nivelRiesgo ?? '-')
            //           : '-',
            //     ),
            //     const SizedBox(width: 12),
            //     if (historial.length >= 2)
            //       Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.trending_up, size: 18, color: Colors.orange.shade700),
            //           const SizedBox(width: 4),
            //           Text(
            //             'Incremento',
            //             style: TextStyle(
            //               fontSize: 12,
            //               color: Colors.orange.shade700,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ],
            //       ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Evolución Temporal del Riesgo',
            //   style: TextStyle(
            //     color: AppColors.navyMedium,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // SizedBox(
            //   height: 160,
            //   child: _buildChart(historial),
            // ),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Factores de Riesgo Identificados (Features ML)',
                style: TextStyle(
                  color: AppColors.navyMedium,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildFeaturesTable(features),
            ],
          ],
        ),
      ),
    );
  }

  Widget _historialChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(List<HistorialPrediccionPerfil> historial) {
    if (historial.isEmpty) {
      return Center(
        child: Text(
          'Sin historial de predicciones',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      );
    }
    final values = historial.map((e) => e.probabilidadAbandono * 100).toList();
    final maxVal = values.isEmpty ? 100.0 : values.reduce((a, b) => a > b ? a : b).clamp(1.0, 100.0);

    return CustomPaint(
      painter: _LineChartPainter(
        values: values,
        maxY: maxVal,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildFeaturesTable(Map<String, dynamic> features) {
    final entries = features.entries.toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columns: const [
          DataColumn(label: Text('Factor', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Valor', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: entries.map((e) {
          return DataRow(
            cells: [
              DataCell(Text(e.key)),
              DataCell(Text(e.value.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;
      const months = [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      return '${d.day} de ${months[d.month - 1]}, ${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values, required this.maxY});

  final List<double> values;
  final double maxY;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final n = values.length;
    final stepX = n > 1 ? (size.width - 32) / (n - 1) : 0.0;
    final padding = 16.0;

    final paint = Paint()
      ..color = AppColors.navyMedium
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < n; i++) {
      final x = padding + i * stepX;
      final y = size.height - padding - (values[i] / maxY * (size.height - 2 * padding));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = AppColors.navyMedium;
    for (var i = 0; i < n; i++) {
      final x = padding + i * stepX;
      final y = size.height - padding - (values[i] / maxY * (size.height - 2 * padding));
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

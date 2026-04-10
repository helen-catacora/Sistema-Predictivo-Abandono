import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const _featureLabels = {
    'Mat': 'Materias aprobadas',
    'Rep': 'Materias reprobadas',
    '2T': 'Materias en 2do turno',
    'Prom': 'Promedio académico',
    'edad': 'Edad',
    'Grado': 'Grado',
    'Genero': 'Género',
    'Semestre': 'Semestre',
    'Carrera': 'Carrera',
    'estrato_socioeconomico': 'Estrato socioeconómico',
    'ocupacion_laboral': 'Ocupación laboral',
    'con_quien_vive': 'Con quién vive',
    'apoyo_economico': 'Apoyo económico',
    'modalidad_ingreso': 'Modalidad de ingreso',
    'tipo_colegio': 'Tipo de colegio',
  };

  static const _numericKeys = {'Mat', 'Rep', '2T', 'Prom', 'edad'};

  @override
  Widget build(BuildContext context) {
    final pred = riesgoYPrediccion?.prediccionActual;
    final features = pred?.featuresUtilizadas ?? {};

    return PerfilSectionCard(
      icon: Icons.show_chart,
      title: 'Análisis de Riesgo - Machine Learning',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProbabilidadCard(pred),
            if (features.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildFeaturesLabel(),
              const SizedBox(height: 8),
              _buildFeaturesTable(features),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilidadCard(PrediccionActualPerfil? pred) {
    const bgColor = Color(0xFFFEF2F2);
    const borderColor = Color(0xFFFECACA);
    const textColor = AppColors.redDC2626;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROBABILIDAD DE ABANDONO',
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${probabilidadPorcentaje.toStringAsFixed(0)}%',
            style: GoogleFonts.inter(
              color: textColor,
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
              backgroundColor: AppColors.greyE2E8F0,
              valueColor: const AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          if (pred?.fechaPrediccion != null) ...[
            const SizedBox(height: 8),
            Text(
              'Última actualización: ${_formatDate(pred!.fechaPrediccion!)}',
              style: GoogleFonts.inter(
                color: AppColors.grey64748B,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturesLabel() {
    return Text(
      'Factores de Riesgo Identificados (Features ML)',
      style: GoogleFonts.inter(
        color: AppColors.black334155,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFeaturesTable(Map<String, dynamic> features) {
    final numeric = features.entries
        .where((e) => _numericKeys.contains(e.key))
        .toList();
    final categorical = features.entries
        .where((e) => !_numericKeys.contains(e.key))
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyE2E8F0),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            if (numeric.isNotEmpty) ...[
              _buildSectionHeader(
                icon: Icons.bar_chart_rounded,
                label: 'VARIABLES NUMÉRICAS',
              ),
              ...numeric.asMap().entries.map(
                (entry) => _buildRow(
                  entry.key,
                  entry.value.key,
                  entry.value.value,
                  isLast: entry.key == numeric.length - 1 &&
                      categorical.isEmpty,
                ),
              ),
            ],
            if (categorical.isNotEmpty) ...[
              _buildSectionHeader(
                icon: Icons.label_outline_rounded,
                label: 'VARIABLES CATEGÓRICAS',
                topBorder: numeric.isNotEmpty,
              ),
              ...categorical.asMap().entries.map(
                (entry) => _buildRow(
                  entry.key,
                  entry.value.key,
                  entry.value.value,
                  isLast: entry.key == categorical.length - 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String label,
    bool topBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.greyF1F5F9,
        border: Border(
          top: topBorder
              ? const BorderSide(color: AppColors.greyE2E8F0)
              : BorderSide.none,
          bottom: const BorderSide(color: AppColors.greyE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.grey64748B),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey64748B,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    int index,
    String key,
    dynamic value, {
    bool isLast = false,
  }) {
    final isEven = index % 2 == 0;
    final isNumeric = _numericKeys.contains(key);
    final label = _featureLabels[key] ?? key;
    final valueStr = value?.toString() ?? '—';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: isEven ? AppColors.white : AppColors.greyF8FAFC,
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.greyE2E8F0),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black334155,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: isNumeric
                  ? Text(
                      valueStr,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray002855,
                      ),
                    )
                  : _buildCategoricalChip(valueStr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoricalChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.greyF1F5F9,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.greyE2E8F0),
      ),
      child: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.grey64748B,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget historialChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: AppColors.grey64748B, fontSize: 11),
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget buildChart(List<HistorialPrediccionPerfil> historial) {
    if (historial.isEmpty) {
      return Center(
        child: Text(
          'Sin historial de predicciones',
          style: GoogleFonts.inter(
            color: AppColors.grey64748B,
            fontSize: 14,
          ),
        ),
      );
    }
    final values = historial.map((e) => e.probabilidadAbandono * 100).toList();
    final maxVal = values.isEmpty
        ? 100.0
        : values.reduce((a, b) => a > b ? a : b).clamp(1.0, 100.0);

    return CustomPaint(
      painter: _LineChartPainter(values: values, maxY: maxVal),
      size: Size.infinite,
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;
      const months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
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
    const padding = 16.0;

    final paint = Paint()
      ..color = AppColors.navyMedium
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < n; i++) {
      final x = padding + i * stepX;
      final y =
          size.height -
          padding -
          (values[i] / maxY * (size.height - 2 * padding));
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
      final y =
          size.height -
          padding -
          (values[i] / maxY * (size.height - 2 * padding));
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

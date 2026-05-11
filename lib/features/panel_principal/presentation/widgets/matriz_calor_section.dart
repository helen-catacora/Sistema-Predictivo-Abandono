import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

/// Matriz de calor de riesgos: tabla Paralelo × Nivel de Riesgo.
/// Widget autocontenido — solo depende de DashboardProvider.
/// Para ocultarlo, comentar el bloque en panel_principal_page.dart.
class MatrizCalorSection extends StatelessWidget {
  const MatrizCalorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    if (provider.status == DashboardStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final paralelos = provider.distribucionPorParalelo;
    if (paralelos.isEmpty) {
      return Container(
        decoration: _cardDecoration(),
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'Sin datos de predicciones por paralelo.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey64748B),
          ),
        ),
      );
    }

    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _HeatTable(paralelos: paralelos),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.gray002855,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Distribución de riesgo por paralelo',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue1E293B,
            ),
          ),
          const SizedBox(width: 12),
          _LegendItem(color: const Color(0xFF16A34A), label: 'Bajo'),
          const SizedBox(width: 10),
          _LegendItem(color: const Color(0xFFF59E0B), label: 'Medio'),
          const SizedBox(width: 10),
          _LegendItem(color: const Color(0xFFF97316), label: 'Alto'),
          const SizedBox(width: 10),
          _LegendItem(color: const Color(0xFFDC2626), label: 'Crítico'),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: AppColors.gray002855, width: 4),
          left: BorderSide(color: AppColors.greyE2E8F0),
          right: BorderSide(color: AppColors.greyE2E8F0),
          bottom: BorderSide(color: AppColors.greyE2E8F0),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey64748B)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tabla de calor
// ---------------------------------------------------------------------------

class _HeatTable extends StatelessWidget {
  const _HeatTable({required this.paralelos});
  final List<DistribucionPorParaleloItem> paralelos;

  // Flex por columna: Paralelo(2) + Área(2) + Bajo(1) + Medio(1) + Alto(1) + Crítico(1) + Total(1)
  static const int _flexParalelo = 2;
  static const int _flexArea = 2;
  static const int _flexNivel = 1;
  static const int _flexTotal = 1;
  static const int _totalFlex = _flexParalelo + _flexArea + (_flexNivel * 4) + _flexTotal;
  // 5 separadores de 16px entre las 7 columnas + padding horizontal de la fila (16×2 = 32)
  static const double _gap = 16;
  static const int _gaps = 6;
  static const double _rowPadding = 32;

  static Map<String, double> _widths(double total) {
    final available = total - (_gap * _gaps) - _rowPadding;
    final unit = available / _totalFlex;
    return {
      'paralelo': unit * _flexParalelo,
      'area': unit * _flexArea,
      'nivel': unit * _flexNivel,
      'total': unit * _flexTotal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final maxBajo = paralelos.map((p) => p.bajoRiesgo).fold(0, (a, b) => a > b ? a : b);
    final maxMedio = paralelos.map((p) => p.medioRiesgo).fold(0, (a, b) => a > b ? a : b);
    final maxAlto = paralelos.map((p) => p.altoRiesgo).fold(0, (a, b) => a > b ? a : b);
    final maxCritico = paralelos.map((p) => p.critico).fold(0, (a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _widths(constraints.maxWidth);
        return Column(
          children: [
            _buildRow(
              w: w,
              paralelo: _hText('PARALELO'),
              area: _hText('ÁREA'),
              bajo: _hText('BAJO', center: true),
              medio: _hText('MEDIO', center: true),
              alto: _hText('ALTO', center: true),
              critico: _hText('CRÍTICO', center: true),
              total: _hText('TOTAL', center: true),
              rowColor: AppColors.gray002855,
            ),
            ...paralelos.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return Column(
                children: [
                  Divider(height: 1, color: AppColors.greyE2E8F0),
                  _buildRow(
                    w: w,
                    paralelo: Text(p.paralelo,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBlue1E293B)),
                    area: Text(p.area,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey64748B)),
                    bajo: _HeatCell(count: p.bajoRiesgo, max: maxBajo, baseColor: const Color(0xFF16A34A)),
                    medio: _HeatCell(count: p.medioRiesgo, max: maxMedio, baseColor: const Color(0xFFF59E0B)),
                    alto: _HeatCell(count: p.altoRiesgo, max: maxAlto, baseColor: const Color(0xFFF97316)),
                    critico: _HeatCell(count: p.critico, max: maxCritico, baseColor: const Color(0xFFDC2626)),
                    total: Center(
                      child: Text('${p.total}',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkBlue1E293B)),
                    ),
                    rowColor: i.isEven ? const Color(0xFFF8FAFC) : Colors.white,
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildRow({
    required Map<String, double> w,
    required Widget paralelo,
    required Widget area,
    required Widget bajo,
    required Widget medio,
    required Widget alto,
    required Widget critico,
    required Widget total,
    Color? rowColor,
  }) {
    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: w['paralelo']!, child: paralelo),
          const SizedBox(width: _gap),
          SizedBox(width: w['area']!, child: area),
          const SizedBox(width: _gap),
          SizedBox(width: w['nivel']!, child: bajo),
          const SizedBox(width: _gap),
          SizedBox(width: w['nivel']!, child: medio),
          const SizedBox(width: _gap),
          SizedBox(width: w['nivel']!, child: alto),
          const SizedBox(width: _gap),
          SizedBox(width: w['nivel']!, child: critico),
          const SizedBox(width: _gap),
          SizedBox(width: w['total']!, child: total),
        ],
      ),
    );
  }

  Widget _hText(String t, {bool center = false}) => Text(
        t,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.white),
      );
}

/// Celda de la matriz de calor: fondo coloreado proporcional al conteo.
class _HeatCell extends StatelessWidget {
  const _HeatCell({
    required this.count,
    required this.max,
    required this.baseColor,
  });

  final int count;
  final int max;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    final intensity = max > 0 ? count / max : 0.0;
    final bg = Color.lerp(Colors.white, baseColor, intensity * 0.75)!;
    final textColor = intensity > 0.5 ? Colors.white : AppColors.darkBlue1E293B;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

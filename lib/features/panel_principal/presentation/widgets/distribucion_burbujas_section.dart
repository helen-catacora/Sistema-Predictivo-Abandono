import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/dashboard_provider.dart';

const _ordenNivelesBurbujas = ['Bajo', 'Medio', 'Alto', 'Critico'];
const _coloresNivelesBurbujas = [
  Color(0xff44AD74),
  Color(0xff4674F5),
  Color(0xffE79914),
  Color(0xffC63627),
];
const _labelsNivelesBurbujas = ['Bajo', 'Medio', 'Alto', 'Crítico'];

/// Sección de distribución de riesgo con gráfico de burbujas (círculos proporcionales).
class DistribucionBurbujasSection extends StatelessWidget {
  const DistribucionBurbujasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final dist = dashboard.distribucionRiesgo;
        final isLoading = dashboard.isLoading;
        final hasError = dashboard.hasError;

        // Construir items en orden Bajo/Medio/Alto/Crítico
        final items = <_BubbleItem>[];
        for (var i = 0; i < _ordenNivelesBurbujas.length; i++) {
          final nivel = _ordenNivelesBurbujas[i];
          int cantidad = 0;
          try {
            cantidad =
                dist.firstWhere((e) => e.nivel == nivel).cantidad;
          } catch (_) {}
          items.add(_BubbleItem(
            label: _labelsNivelesBurbujas[i],
            count: cantidad,
            color: _coloresNivelesBurbujas[i],
          ));
        }

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
                        'Gráfico de burbujas',
                        style: TextStyle(
                          color: AppColors.navyMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isLoading && items.every((e) => e.count == 0))
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (hasError)
                    Expanded(
                      child: Center(
                        child: Text(
                          dashboard.errorMessage ?? 'Error al cargar',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    const SizedBox(height: 12),
                    Expanded(
                      child: CustomPaint(
                        painter: _BubbleChartPainter(items),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Leyenda inferior
                    Center(
                      child: Wrap(
                        spacing: 16,
                        children: [
                          for (var i = 0;
                              i < _labelsNivelesBurbujas.length;
                              i++)
                            _LegendDot(
                              color: _coloresNivelesBurbujas[i],
                              label: _labelsNivelesBurbujas[i],
                            ),
                        ],
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

// ── Modelo de burbuja ─────────────────────────────────────────────────────────

class _BubbleItem {
  const _BubbleItem({
    required this.label,
    required this.count,
    required this.color,
  });
  final String label;
  final int count;
  final Color color;
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _BubbleChartPainter extends CustomPainter {
  const _BubbleChartPainter(this.items);
  final List<_BubbleItem> items;

  static const double _maxRadius = 72.0;
  static const double _minRadius = 26.0;
  static const double _padding = 16.0;

  // Factor de distancia para p1 y p2 respecto al ancla p0.
  // 0.93 → los círculos quedan muy próximos con un solapamiento mínimo (~7%).
  static const double _overlapFactor = 0.93;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final maxCount =
        items.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    // ── 1. Radios proporcionales al área ─────────────────────────────────────
    final radii = items.map((e) {
      if (maxCount == 0) return _minRadius;
      return (sqrt(e.count / maxCount) * _maxRadius).clamp(
        _minRadius,
        _maxRadius,
      );
    }).toList();

    // ── 2. Ordenar por tamaño para el empaquetado (mayor → posición ancla) ───
    // Se guarda el índice original para mantener color y etiqueta correctos.
    final sorted = List.generate(items.length, (i) => i)
      ..sort((a, b) => radii[b].compareTo(radii[a])); // desc por radio

    // radii y positions en orden [p0, p1, p2, p3] según tamaño
    final sortedRadii = sorted.map((i) => radii[i]).toList();

    // ── 3. Empaquetado en diamante con superposición ──────────────────────────
    // p0 (más grande) — izquierda
    // p1 (2.º)        — arriba-derecha, se superpone con p0
    // p2 (3.º)        — abajo-derecha,  se superpone con p0
    // p3 (más pequeño)— derecha, se superpone con p1 y p2
    final positions = _packDiamond(sortedRadii);

    // Reordenar posiciones de vuelta al orden original [Bajo,Medio,Alto,Crítico]
    final finalPositions = List<Offset>.filled(items.length, Offset.zero);
    for (var si = 0; si < sorted.length; si++) {
      finalPositions[sorted[si]] = positions[si];
    }

    // ── 4. Caja envolvente incluyendo radios ─────────────────────────────────
    double minX = double.infinity, maxX = -double.infinity;
    double minY = double.infinity, maxY = -double.infinity;
    for (var i = 0; i < finalPositions.length; i++) {
      if (finalPositions[i].dx - radii[i] < minX) minX = finalPositions[i].dx - radii[i];
      if (finalPositions[i].dx + radii[i] > maxX) maxX = finalPositions[i].dx + radii[i];
      if (finalPositions[i].dy - radii[i] < minY) minY = finalPositions[i].dy - radii[i];
      if (finalPositions[i].dy + radii[i] > maxY) maxY = finalPositions[i].dy + radii[i];
    }

    final clusterW = maxX - minX;
    final clusterH = maxY - minY;

    // ── 5. Escala uniforme para llenar el canvas ──────────────────────────────
    final availW = size.width - _padding * 2;
    final availH = size.height - _padding * 2;
    final scale = (clusterW > 0 && clusterH > 0)
        ? min(availW / clusterW, availH / clusterH).clamp(0.1, 2.0)
        : 1.0;

    final clusterCx = (minX + maxX) / 2;
    final clusterCy = (minY + maxY) / 2;

    // ── 6. Dibujar cada círculo ───────────────────────────────────────────────
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final r = radii[i] * scale;
      final center = Offset(
        size.width / 2 + (finalPositions[i].dx - clusterCx) * scale,
        size.height / 2 + (finalPositions[i].dy - clusterCy) * scale,
      );

      // Relleno
      canvas.drawCircle(
        center,
        r,
        Paint()..color = item.color.withValues(alpha: 0.90),
      );
      // Borde sutil
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = item.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Etiqueta (arriba del centro) — igual que en la referencia
      final lblSize = (r * 0.27).clamp(9.0, 14.0);
      final labelPainter = TextPainter(
        text: TextSpan(
          text: item.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: lblSize,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r * 2);
      labelPainter.paint(
        canvas,
        center + Offset(-labelPainter.width / 2, -labelPainter.height / 2 - r * 0.14),
      );

      // Número (abajo del centro) — igual que en la referencia
      final numSize = (r * 0.38).clamp(11.0, 22.0);
      final countPainter = TextPainter(
        text: TextSpan(
          text: item.count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: numSize,
            fontWeight: FontWeight.w900,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r * 2);
      countPainter.paint(
        canvas,
        center + Offset(-countPainter.width / 2, -countPainter.height / 2 + r * 0.14),
      );
    }
  }

  /// Disposición en diamante con superposición (_overlapFactor):
  /// p0 (más grande) — izquierda
  /// p1 (2.º)        — arriba-derecha, solapado con p0
  /// p2 (3.º)        — abajo-derecha,  solapado con p0
  /// p3 (más pequeño)— derecha, solapado con p1 y p2
  static List<Offset> _packDiamond(List<double> r) {
    const sqrt2over2 = 0.7071067811865476; // √2/2

    final p0 = Offset.zero;

    // p1 a 45° arriba-derecha; distancia reducida para solapar
    final d01 = (r[0] + r[1]) * _overlapFactor;
    final p1 = Offset(d01 * sqrt2over2, -d01 * sqrt2over2);

    // p2 a 45° abajo-derecha; distancia reducida para solapar
    final d02 = (r[0] + r[2]) * _overlapFactor;
    final p2 = Offset(d02 * sqrt2over2, d02 * sqrt2over2);

    // p3: solapado con p1 y p2, en el lado más a la derecha
    final p3 = _tangentRight(p1, r[1], p2, r[2], r[3]);

    return [p0, p1, p2, p3];
  }

  /// Devuelve el centro del círculo de radio [r3] tangente a los dos círculos
  /// dados, eligiendo la solución con mayor coordenada X (lado derecho).
  static Offset _tangentRight(
    Offset cA,
    double rA,
    Offset cB,
    double rB,
    double r3,
  ) {
    final a = rA + r3;
    final b = rB + r3;
    final dx = cB.dx - cA.dx;
    final dy = cB.dy - cA.dy;
    final d = sqrt(dx * dx + dy * dy);

    if (d < 0.001) return cA + Offset(a, 0); // caso degenerado

    // Coordenada local a lo largo del eje cA→cB
    final xLocal = (a * a - b * b + d * d) / (2.0 * d);
    final ySq = a * a - xLocal * xLocal;
    final yLocal = ySq > 0 ? sqrt(ySq) : 0.0;

    // Vectores unitario (eje) y perpendicular
    final ux = dx / d;
    final uy = dy / d;
    final px = -uy; // perpendicular: rotación +90°
    final py = ux;

    final s1 = Offset(
      cA.dx + xLocal * ux + yLocal * px,
      cA.dy + xLocal * uy + yLocal * py,
    );
    final s2 = Offset(
      cA.dx + xLocal * ux - yLocal * px,
      cA.dy + xLocal * uy - yLocal * py,
    );

    // Elegir la solución más a la derecha (mayor X)
    return s1.dx >= s2.dx ? s1 : s2;
  }

  @override
  bool shouldRepaint(_BubbleChartPainter old) => !listEquals(
        old.items.map((e) => e.count).toList(),
        items.map((e) => e.count).toList(),
      );
}

// ── Leyenda ───────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.grayDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/metricas_modelo.dart';

/// Card de comparación de métricas entre modelo actual y candidato.
class MetricasComparisonCard extends StatelessWidget {
  const MetricasComparisonCard({
    super.key,
    required this.metricasNuevo,
    required this.metricasActual,
    required this.tipoMejorModelo,
    required this.onAceptar,
    required this.onRechazar,
    this.isProcessing = false,
  });

  final MetricasModelo metricasNuevo;
  final MetricasModelo? metricasActual;
  final String tipoMejorModelo;
  final VoidCallback onAceptar;
  final VoidCallback onRechazar;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final mejorF1 = metricasActual == null ||
        metricasNuevo.f1Score >= metricasActual!.f1Score;

    final borderColor =
        mejorF1 ? const Color(0xff22C55E) : AppColors.redDC2626;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: borderColor, width: 4),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                mejorF1 ? Icons.trending_up : Icons.trending_down,
                color: mejorF1 ? AppColors.green16A34A : AppColors.redDC2626,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Resultado del Entrenamiento',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1E293B),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff002855).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tipoMejorModelo,
                  style: GoogleFonts.inter(
                    color: const Color(0xff002855),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mejorF1
                ? 'El nuevo modelo supera o iguala al actual. Se recomienda aceptar.'
                : 'El modelo actual tiene mejor F1-Score. No se recomienda reemplazar.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: mejorF1 ? AppColors.green15803D : AppColors.redDC2626,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Tabla comparativa
          _buildTabla(),
          const SizedBox(height: 24),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: isProcessing ? null : () => _confirmarRechazar(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.redDC2626, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.close, size: 18, color: AppColors.redDC2626),
                      const SizedBox(width: 8),
                      Text(
                        'RECHAZAR',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.redDC2626,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: isProcessing ? null : () => _confirmarAceptar(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.green16A34A,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      isProcessing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 18,
                              color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'ACEPTAR Y REEMPLAZAR',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabla() {
    final metricas = [
      ('F1-Score', metricasActual?.f1Score, metricasNuevo.f1Score),
      ('Precision', metricasActual?.precision, metricasNuevo.precision),
      ('Recall', metricasActual?.recall, metricasNuevo.recall),
      ('ROC-AUC', metricasActual?.rocAuc, metricasNuevo.rocAuc),
      ('Accuracy', metricasActual?.accuracy, metricasNuevo.accuracy),
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      border: TableBorder.all(
        color: AppColors.greyE2E8F0,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.greyF1F5F9,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _headerCell('Métrica'),
            _headerCell('Modelo Actual'),
            _headerCell('Modelo Nuevo'),
            _headerCell('Diferencia'),
          ],
        ),
        // Rows
        for (final (nombre, actual, nuevo) in metricas)
          TableRow(
            children: [
              _dataCell(nombre, fontWeight: FontWeight.w600),
              _dataCell(actual != null ? actual.toStringAsFixed(4) : 'N/A'),
              _dataCell(nuevo.toStringAsFixed(4)),
              _diffCell(actual, nuevo),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xff1E293B),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dataCell(String text, {FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: fontWeight,
          color: const Color(0xff1E293B),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _diffCell(double? actual, double nuevo) {
    if (actual == null) {
      return _dataCell('-');
    }
    final diff = nuevo - actual;
    final color = diff >= 0 ? AppColors.green16A34A : AppColors.redDC2626;
    final icon = diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(4)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarAceptar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar reemplazo'),
        content: const Text(
          'Esta acción reemplazará el modelo actual. '
          'Las predicciones futuras usarán el nuevo modelo. '
          '¿Desea continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onAceptar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green16A34A,
              foregroundColor: Colors.white,
            ),
            child: const Text('Aceptar y Reemplazar'),
          ),
        ],
      ),
    );
  }

  void _confirmarRechazar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rechazar modelo'),
        content: const Text(
          '¿Desea descartar el modelo candidato? '
          'El modelo actual no será modificado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRechazar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redDC2626,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }
}

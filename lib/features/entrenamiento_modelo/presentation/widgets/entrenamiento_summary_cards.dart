import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/entrenamiento_historial_item.dart';
import '../../data/models/modelo_actual_response.dart';

/// Tarjetas laterales: Modelo Actual + Estadísticas de Entrenamientos.
class EntrenamientoSummaryCards extends StatelessWidget {
  const EntrenamientoSummaryCards({
    super.key,
    required this.modelo,
    required this.isLoading,
    required this.historial,
  });

  final ModeloActualResponse? modelo;
  final bool isLoading;
  final List<EntrenamientoHistorialItem> historial;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ModeloActualCard(modelo: modelo, isLoading: isLoading),
        const SizedBox(height: 16),
        _EstadisticasCard(totalEntrenamientos: historial.length),
      ],
    );
  }
}

/// Card con información del modelo actual — borde izquierdo verde.
class _ModeloActualCard extends StatelessWidget {
  const _ModeloActualCard({required this.modelo, required this.isLoading});

  final ModeloActualResponse? modelo;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final tieneModelo = modelo != null;
    final statusColor =
        tieneModelo ? const Color(0xff16A34A) : const Color(0xff64748B);
    final bgColor =
        tieneModelo ? const Color(0xffF0FDF4) : const Color(0xffF1F5F9);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            const Border(left: BorderSide(color: Color(0xff22C55E), width: 4)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(24),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.psychology, color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modelo de Predicción',
                            style: GoogleFonts.inter(
                              color: const Color(0xff1E293B),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            tieneModelo ? 'Activo' : 'Sin modelo cargado',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _infoRow('Versión:', modelo?.version ?? '—'),
                const SizedBox(height: 8),
                _infoRow('Tipo:', modelo?.tipoModelo ?? '—'),
                const SizedBox(height: 8),
                _infoRow(
                  'F1-Score:',
                  modelo?.metricas.f1Score.toStringAsFixed(4) ?? '—',
                ),
                const SizedBox(height: 8),
                _infoRow(
                  'Precision:',
                  modelo?.metricas.precision.toStringAsFixed(4) ?? '—',
                ),
                const SizedBox(height: 8),
                _infoRow(
                  'Recall:',
                  modelo?.metricas.recall.toStringAsFixed(4) ?? '—',
                ),
                const SizedBox(height: 8),
                _infoRow(
                  'ROC-AUC:',
                  modelo?.metricas.rocAuc.toStringAsFixed(4) ?? '—',
                ),
                const SizedBox(height: 8),
                _infoRow(
                  'Accuracy:',
                  modelo?.metricas.accuracy.toStringAsFixed(4) ?? '—',
                ),
              ],
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xff64748B),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            color: const Color(0xff334155),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 20 / 14,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

/// Card de estadísticas de entrenamientos — borde izquierdo amarillo.
class _EstadisticasCard extends StatelessWidget {
  const _EstadisticasCard({required this.totalEntrenamientos});

  final int totalEntrenamientos;

  @override
  Widget build(BuildContext context) {
    final totalStr = totalEntrenamientos.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
            left: BorderSide(color: Color(0xffFFD60A), width: 4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFCE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_graph_sharp,
                    color: Color(0xffFFD60A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas',
                      style: GoogleFonts.inter(
                        color: const Color(0xff1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 24 / 16,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      'Total de Entrenamientos',
                      style: GoogleFonts.inter(
                        color: const Color(0xff64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    totalStr,
                    style: GoogleFonts.inter(
                      color: const Color(0xff002855),
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 40 / 36,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ENTRENAMIENTOS REALIZADOS',
                    style: GoogleFonts.inter(
                      color: const Color(0xff64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      letterSpacing: 0,
                    ),
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

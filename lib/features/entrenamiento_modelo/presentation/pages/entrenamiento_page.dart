import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/refresh_button.dart';
import '../../../../shared/widgets/screen_description_card.dart';
import '../providers/entrenamiento_provider.dart';
import '../widgets/entrenamiento_file_selector.dart';
import '../widgets/entrenamiento_historial_table.dart';
import '../widgets/entrenamiento_instructions_panel.dart';
import '../widgets/entrenamiento_progress_card.dart';
import '../widgets/entrenamiento_summary_cards.dart';
import '../widgets/metricas_comparison_card.dart';

/// Página de entrenamiento/reentrenamiento del modelo ML.
class EntrenamientoPage extends StatefulWidget {
  const EntrenamientoPage({super.key});

  @override
  State<EntrenamientoPage> createState() => _EntrenamientoPageState();
}

class _EntrenamientoPageState extends State<EntrenamientoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<EntrenamientoProvider>();
      provider.loadModeloActual();
      provider.loadHistorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntrenamientoProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final isMobile = Responsive.isMobile(w);
                        final fontSize = Responsive.pageTitleFontSize(w);
                        final titleText = Text(
                          'Entrenamiento del Modelo Predictivo',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        );
                        final refreshBtn = RefreshButton(
                          onTap: () {
                            provider.loadModeloActual();
                            provider.loadHistorial();
                          },
                        );
                        if (isMobile) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleText,
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: refreshBtn,
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [titleText, refreshBtn],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const ScreenDescriptionCard(
                      description:
                          'Entrene o reentrene el modelo de predicción de abandono estudiantil '
                          'subiendo datos en formato Excel. Compare las métricas del nuevo modelo '
                          'con el actual y decida si desea reemplazarlo.',
                      icon: Icons.model_training,
                    ),
                    const SizedBox(height: 24),

                    // Mensajes de error/éxito
                    if (provider.errorMessage != null)
                      _buildMessage(
                        provider.errorMessage!,
                        AppColors.redDC2626,
                        Icons.error_outline,
                        onDismiss: provider.clearError,
                      ),
                    if (provider.successMessage != null)
                      _buildMessage(
                        provider.successMessage!,
                        AppColors.green16A34A,
                        Icons.check_circle_outline,
                        onDismiss: provider.reset,
                      ),

                    // Progreso (visible durante entrenamiento)
                    if (provider.estado == EntrenamientoEstado.uploading ||
                        provider.estado == EntrenamientoEstado.training)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: EntrenamientoProgressCard(
                          estado:
                              provider.estadoResponse?.estado ?? 'pendiente',
                          nombreArchivo:
                              provider.estadoResponse?.nombreArchivo ?? '...',
                          totalRegistros:
                              provider.estadoResponse?.totalRegistros ?? 0,
                        ),
                      ),

                    // Comparación de métricas (visible post-entrenamiento)
                    if (provider.estado == EntrenamientoEstado.comparing &&
                        provider.estadoResponse?.metricasNuevo != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: MetricasComparisonCard(
                          metricasNuevo:
                              provider.estadoResponse!.metricasNuevo!,
                          metricasActual:
                              provider.estadoResponse!.metricasActual,
                          tipoMejorModelo:
                              provider.estadoResponse!.tipoMejorModelo ??
                                  'Desconocido',
                          onAceptar: provider.aceptarModelo,
                          onRechazar: provider.rechazarModelo,
                          isProcessing: provider.estado ==
                                  EntrenamientoEstado.accepting ||
                              provider.estado == EntrenamientoEstado.rejecting,
                        ),
                      ),

                    // Instrucciones + Modelo Actual (responsive)
                    if (provider.estado != EntrenamientoEstado.comparing)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final useRow = constraints.maxWidth > 900;
                          if (useRow) {
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: EntrenamientoInstructionsPanel(),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 1,
                                    child: EntrenamientoSummaryCards(
                                      modelo: provider.modeloActual,
                                      isLoading:
                                          provider.isLoadingModeloActual,
                                      historial: provider.historial,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: [
                              const SizedBox(
                                height: 380,
                                child: EntrenamientoInstructionsPanel(),
                              ),
                              const SizedBox(height: 24),
                              EntrenamientoSummaryCards(
                                modelo: provider.modeloActual,
                                isLoading: provider.isLoadingModeloActual,
                                historial: provider.historial,
                              ),
                            ],
                          );
                        },
                      ),

                    if (provider.estado != EntrenamientoEstado.comparing)
                      const SizedBox(height: 24),

                    // Selector de archivo (oculto durante comparación)
                    if (provider.estado != EntrenamientoEstado.comparing)
                      const EntrenamientoFileSelector(),

                    const SizedBox(height: 24),

                    // Historial
                    // EntrenamientoHistorialTable(
                    //   historial: provider.historial,
                    //   isLoading: provider.isLoadingHistorial,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessage(
    String message,
    Color color,
    IconData icon, {
    VoidCallback? onDismiss,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: color == AppColors.redDC2626
            ? Colors.red.shade50
            : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: color, fontSize: 13),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

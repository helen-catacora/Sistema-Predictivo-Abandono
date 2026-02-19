// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../../../estudiantes/data/models/estudiante_item.dart';
import '../../../estudiantes/presentation/providers/estudiantes_provider.dart';
import '../../data/models/reporte_tipo_item.dart';
// En web: dart.library.io no existe, se usa pdf_download_web (blob). En móvil/escritorio: se usa pdf_download_stub (File).
import '../../utils/pdf_download_web.dart'
    if (dart.library.io) '../../utils/pdf_download_stub.dart'
    as pdf_util;
import '../providers/reportes_tipos_provider.dart';

/// Ícono por tipo de reporte.
IconData _iconForTipo(String tipo) {
  switch (tipo) {
    case 'predictivo_general':
      return Icons.show_chart;
    case 'estudiantes_riesgo':
      return Icons.people_outline;
    case 'por_paralelo':
      return Icons.description_outlined;
    case 'asistencia':
      return Icons.calendar_month;
    case 'individual':
      return Icons.person_outline;
    default:
      return Icons.description_outlined;
  }
}

Color _backGroundColorForTipo(String tipo) {
  switch (tipo) {
    case 'predictivo_general':
      return Color(0xffDBEAFE);
    case 'estudiantes_riesgo':
      return Color(0xffFEF3C7);
    case 'por_paralelo':
      return Color(0xffF3E8FF);
    case 'asistencia':
      return Color(0xffFEE2E2);
    case 'individual':
      return Color(0xffCFFAFE);
    default:
      return Color(0xffCFFAFE);
  }
}

Color _iconColorForTipo(String tipo) {
  switch (tipo) {
    case 'predictivo_general':
      return Color(0xff002855);
    case 'estudiantes_riesgo':
      return Color(0xffD97706);
    case 'por_paralelo':
      return Color(0xff9333EA);
    case 'asistencia':
      return Color(0xffDC2626);
    case 'individual':
      return Color(0xff0891B2);
    default:
      return Color(0xff0891B2);
  }
}

/// Sección de reportes disponibles (datos de GET /reportes/tipos).
class ReportsAvailableSection extends StatelessWidget {
  const ReportsAvailableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: AppColors.gray002855, width: 4)),
      ),
      child: Consumer<ReportesTiposProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.isLoading;
          final hasError = provider.hasError;
          final tipos = provider.tipos;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                        'Reportes Disponibles',
                        style: GoogleFonts.inter(
                          color: AppColors.darkBlue1E293B,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 28 / 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isLoading && tipos.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando reportes disponibles...'),
                      ],
                    ),
                  ),
                )
              else if (hasError && tipos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    provider.errorMessage ??
                        'Error al cargar tipos de reportes',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                )
              else if (tipos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No hay tipos de reportes disponibles.',
                    style: TextStyle(color: AppColors.grayMedium, fontSize: 13),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    const crossAxisSpacing = 24.0;
                    const mainAxisSpacing = 20.0;
                    const minCardWidth = 280.0;
                    const cardAspectRatio = 330 / 250;
                    final width = constraints.maxWidth;
                    final crossAxisCount =
                        (width / (minCardWidth + crossAxisSpacing)).floor();
                    final columnCount = max(3, crossAxisCount);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: mainAxisSpacing,
                        childAspectRatio: cardAspectRatio,
                      ),
                      itemCount: tipos.length,
                      itemBuilder: (context, index) {
                        final reportType = tipos[index];
                        return _ReportTemplateCard(
                          item: reportType,
                          onGenerar: () =>
                              _onGenerarReporte(context, reportType),
                        );
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onGenerarReporte(
    BuildContext context,
    ReporteTipoItem item,
  ) async {
    final reportesProvider = context.read<ReportesTiposProvider>();
    if (reportesProvider.isGenerating) return;

    int? paraleloId;
    int? estudianteId;

    if (item.requiereParalelo) {
      final paralelosProvider = context.read<ParalelosProvider>();
      if (paralelosProvider.paralelos.isEmpty) {
        await paralelosProvider.loadParalelos();
      }
      if (!context.mounted) return;
      final selected = await _showParaleloPicker(
        context,
        paralelosProvider.paralelos,
      );
      if (selected == null) return;
      paraleloId = selected.id;
    }

    if (item.requiereEstudiante) {
      final estudiantesProvider = context.read<EstudiantesProvider>();
      if (estudiantesProvider.estudiantes.isEmpty) {
        await estudiantesProvider.loadEstudiantes();
      }
      if (!context.mounted) return;
      final selected = await _showEstudiantePicker(
        context,
        estudiantesProvider.estudiantes,
      );
      if (selected == null) return;
      estudianteId = selected.id;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generando reporte...')));

    try {
      final bytes = await reportesProvider.generarReporte(
        item,
        paraleloId: paraleloId,
        estudianteId: estudianteId,
      );
      if (!context.mounted) return;
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se recibieron datos del reporte')),
        );
        return;
      }
      final filename = 'reporte_${item.tipo}.pdf';
      final path = pdf_util.savePdf(bytes, filename);
      if (!context.mounted) return;
      if (path != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF guardado en: $path')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Descarga iniciada')));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<ParaleloItem?> _showParaleloPicker(
    BuildContext context,
    List<ParaleloItem> paralelos,
  ) async {
    if (paralelos.isEmpty) return null;
    ParaleloItem? selected = paralelos.first;
    return showDialog<ParaleloItem>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seleccionar paralelo'),
        content: StatefulBuilder(
          builder: (ctx, setState) => DropdownButton<ParaleloItem>(
            value: selected,
            isExpanded: true,
            items: paralelos
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text('${p.nombre} (ID: ${p.id})'),
                  ),
                )
                .toList(),
            onChanged: (p) => setState(() => selected = p),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(selected),
            child: const Text('Generar'),
          ),
        ],
      ),
    );
  }

  Future<EstudianteItem?> _showEstudiantePicker(
    BuildContext context,
    List<EstudianteItem> estudiantes,
  ) async {
    if (estudiantes.isEmpty) return null;
    EstudianteItem? selected = estudiantes.first;
    return showDialog<EstudianteItem>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seleccionar estudiante'),
        content: StatefulBuilder(
          builder: (ctx, setState) => DropdownButton<EstudianteItem>(
            value: selected,
            isExpanded: true,
            items: estudiantes
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text('${e.nombreCompleto} (${e.codigoEstudiante})'),
                  ),
                )
                .toList(),
            onChanged: (e) => setState(() => selected = e),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(selected),
            child: const Text('Generar'),
          ),
        ],
      ),
    );
  }
}

class _ReportTemplateCard extends StatelessWidget {
  const _ReportTemplateCard({required this.item, required this.onGenerar});

  final ReporteTipoItem item;
  final VoidCallback onGenerar;

  @override
  Widget build(BuildContext context) {
    final icon = _iconForTipo(item.tipo);
    final iconBackGroundColor = _backGroundColorForTipo(item.tipo);
    final iconColor = _iconColorForTipo(item.tipo);
    final badges = <String>[];
    if (item.requiereParalelo) badges.add('Requiere paralelo');
    if (item.requiereEstudiante) badges.add('Requiere estudiante');

    return Consumer<ReportesTiposProvider>(
      builder: (context, provider, _) {
        final isGenerating = provider.isGeneratingTipo(item.tipo);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyF8FAFC,
            border: Border.all(color: AppColors.greyE2E8F0, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: iconBackGroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(icon, color: iconColor, size: 24),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffDCFCE7),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'ACTIVO',
                        style: GoogleFonts.inter(
                          color: AppColors.green15803D,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 16 / 12,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  item.nombre,
                  style: GoogleFonts.inter(
                    color: AppColors.darkBlue1E293B,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.descripcion,
                  style: GoogleFonts.inter(
                    color: AppColors.grey64748B,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (badges.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: badges
                            .map(
                              (b) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blueLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  b,
                                  style: const TextStyle(
                                    color: AppColors.navyMedium,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    Spacer(),
                    FilledButton(
                      onPressed: isGenerating ? null : onGenerar,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'GENERAR',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.gray002855,
                                fontWeight: FontWeight.w700,
                                height: 16 / 12,
                                letterSpacing: 0,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

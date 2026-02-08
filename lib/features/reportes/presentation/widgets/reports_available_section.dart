import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../../../estudiantes/data/models/estudiante_item.dart';
import '../../../estudiantes/presentation/providers/estudiantes_provider.dart';
import '../../data/models/reporte_tipo_item.dart';
import '../../utils/pdf_download_stub.dart' if (dart.library.html) '../../utils/pdf_download_web.dart' as pdf_util;
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

/// Sección de reportes disponibles (datos de GET /reportes/tipos).
class ReportsAvailableSection extends StatelessWidget {
  const ReportsAvailableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportesTiposProvider>(
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
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accentYellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Reportes Disponibles',
                      style: TextStyle(
                        color: AppColors.navyMedium,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('NUEVO REPORTE'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                  ),
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
                  provider.errorMessage ?? 'Error al cargar tipos de reportes',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              )
            else if (tipos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No hay tipos de reportes disponibles.',
                  style: TextStyle(
                    color: AppColors.grayMedium,
                    fontSize: 13,
                  ),
                ),
              )
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: tipos
                    .map((item) => _ReportTemplateCard(
                          item: item,
                          onGenerar: () => _onGenerarReporte(context, item),
                        ))
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  Future<void> _onGenerarReporte(BuildContext context, ReporteTipoItem item) async {
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
      final selected = await _showParaleloPicker(context, paralelosProvider.paralelos);
      if (selected == null) return;
      paraleloId = selected.id;
    }

    if (item.requiereEstudiante) {
      final estudiantesProvider = context.read<EstudiantesProvider>();
      if (estudiantesProvider.estudiantes.isEmpty) {
        await estudiantesProvider.loadEstudiantes();
      }
      if (!context.mounted) return;
      final selected = await _showEstudiantePicker(context, estudiantesProvider.estudiantes);
      if (selected == null) return;
      estudianteId = selected.id;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando reporte...')),
    );

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF guardado en: $path')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Descarga iniciada')),
        );
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

  Future<ParaleloItem?> _showParaleloPicker(BuildContext context, List<ParaleloItem> paralelos) async {
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
                .map((p) => DropdownMenuItem(value: p, child: Text('${p.nombre} (ID: ${p.id})')))
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

  Future<EstudianteItem?> _showEstudiantePicker(BuildContext context, List<EstudianteItem> estudiantes) async {
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
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('${e.nombreCompleto} (${e.codigoEstudiante})'),
                    ))
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
    final badges = <String>[];
    if (item.requiereParalelo) badges.add('Requiere paralelo');
    if (item.requiereEstudiante) badges.add('Requiere estudiante');

    return Consumer<ReportesTiposProvider>(
      builder: (context, provider, _) {
        final isGenerating = provider.isGenerating;

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
                  children: [
                    Icon(icon, color: AppColors.navyMedium, size: 28),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ACTIVO',
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.nombre,
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.descripcion,
                  style: TextStyle(
                    color: AppColors.grayMedium,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (badges.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: badges
                        .map((b) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
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
                            ))
                        .toList(),
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: isGenerating ? null : onGenerar,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navyMedium,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('GENERAR'),
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

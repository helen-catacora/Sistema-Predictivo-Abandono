// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
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

String _nombreArea(int areaId) {
  switch (areaId) {
    case 1:
      return 'Tecnologicas';
    case 2:
      return 'No Tecnologicas';
    default:
      return 'Área $areaId';
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
          final screenWidth = MediaQuery.of(context).size.width;
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
                          fontSize: Responsive.titleFontSize(screenWidth),
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
                    const cardAspectRatio = 330 / 260;
                    final width = constraints.maxWidth;
                    final crossAxisCount =
                        (width / (minCardWidth + crossAxisSpacing)).floor();
                    final columnCount = max(1, crossAxisCount);

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

    // Reporte por paralelo: solo necesita paralelo_id.
    if (item.requiereParalelo && !item.requiereEstudiante) {
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

    // Reporte individual: diálogo unificado con pestaña "Por Paralelo" y "Búsqueda".
    if (item.requiereEstudiante) {
      final paralelosProvider = context.read<ParalelosProvider>();
      final estudiantesProvider = context.read<EstudiantesProvider>();
      if (paralelosProvider.paralelos.isEmpty) {
        await paralelosProvider.loadParalelos();
      }
      if (!context.mounted) return;
      final selected = await showDialog<EstudianteItem>(
        context: context,
        builder: (_) => _EstudiantePickerDialog(
          paralelos: paralelosProvider.paralelos,
          estudiantesProvider: estudiantesProvider,
        ),
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
    return showDialog<ParaleloItem>(
      context: context,
      builder: (_) => _ParaleloPickerDialog(paralelos: paralelos),
    );
  }
}

/// Diálogo para seleccionar paralelo en el reporte "Por Paralelo".
class _ParaleloPickerDialog extends StatefulWidget {
  const _ParaleloPickerDialog({required this.paralelos});

  final List<ParaleloItem> paralelos;

  @override
  State<_ParaleloPickerDialog> createState() => _ParaleloPickerDialogState();
}

class _ParaleloPickerDialogState extends State<_ParaleloPickerDialog> {
  final TextEditingController _searchCtrl = TextEditingController();
  ParaleloItem? _seleccionado;

  @override
  void initState() {
    super.initState();
    if (widget.paralelos.isNotEmpty) _seleccionado = widget.paralelos.first;
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ParaleloItem> get _filtrados {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return widget.paralelos;
    return widget.paralelos.where((p) {
      return p.nombre.toLowerCase().contains(q) ||
          _nombreArea(p.areaId).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: _buildHeader(),
      content: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar paralelo...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchCtrl.clear(),
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              if (_seleccionado != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffDBEAFE),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.gray002855, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.gray002855, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_seleccionado!.nombre} — ${_nombreArea(_seleccionado!.areaId)}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray002855,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: _filtrados.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Sin resultados para "${_searchCtrl.text}"',
                            style: TextStyle(
                                color: AppColors.grayMedium, fontSize: 13),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filtrados.length,
                        separatorBuilder: (_, idx) =>
                            const Divider(height: 1, indent: 12, endIndent: 12),
                        itemBuilder: (_, i) {
                          final p = _filtrados[i];
                          final isSelected = _seleccionado?.id == p.id;
                          final areaNombre = _nombreArea(p.areaId);
                          return ListTile(
                            dense: true,
                            selected: isSelected,
                            selectedTileColor: const Color(0xffDBEAFE),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected
                                  ? AppColors.gray002855
                                  : const Color(0xffE2E8F0),
                              child: Text(
                                areaNombre.isNotEmpty
                                    ? areaNombre[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.darkBlue1E293B,
                                ),
                              ),
                            ),
                            title: Text(
                              p.nombre,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              areaNombre,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.grayMedium,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle,
                                    color: AppColors.gray002855, size: 18)
                                : null,
                            onTap: () =>
                                setState(() => _seleccionado = p),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _seleccionado != null
              ? () => Navigator.of(context).pop(_seleccionado)
              : null,
          child: const Text('Generar'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray002855,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.description_outlined,
              color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Seleccionar Paralelo',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo unificado para seleccionar estudiante en el reporte individual.
/// Ofrece dos modos: filtrar por paralelo o buscar directamente por nombre/código.
class _EstudiantePickerDialog extends StatefulWidget {
  const _EstudiantePickerDialog({
    required this.paralelos,
    required this.estudiantesProvider,
  });

  final List<ParaleloItem> paralelos;
  final EstudiantesProvider estudiantesProvider;

  @override
  State<_EstudiantePickerDialog> createState() =>
      _EstudiantePickerDialogState();
}

class _EstudiantePickerDialogState extends State<_EstudiantePickerDialog> {
  // 0 = Por Paralelo, 1 = Búsqueda
  int _modo = 0;

  // --- Pestaña "Por Paralelo" ---
  ParaleloItem? _paraleloSeleccionado;
  List<EstudianteItem> _estudiantesDelParalelo = [];
  EstudianteItem? _estudianteDelParalelo;
  bool _cargandoParalelo = false;
  String? _errorParalelo;

  // --- Pestaña "Búsqueda" ---
  final TextEditingController _searchCtrl = TextEditingController();
  List<EstudianteItem> _todos = [];
  bool _cargandoTodos = false;
  bool _todosLoaded = false;
  String? _errorBusqueda;
  EstudianteItem? _estudianteBusqueda;

  EstudianteItem? get _seleccionado =>
      _modo == 0 ? _estudianteDelParalelo : _estudianteBusqueda;

  @override
  void initState() {
    super.initState();
    if (widget.paralelos.isNotEmpty) {
      _paraleloSeleccionado = widget.paralelos.first;
      _cargarEstudiantesDelParalelo(widget.paralelos.first.id);
    }
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarEstudiantesDelParalelo(int paraleloId) async {
    setState(() {
      _cargandoParalelo = true;
      _errorParalelo = null;
      _estudiantesDelParalelo = [];
      _estudianteDelParalelo = null;
    });
    final lista =
        await widget.estudiantesProvider.getEstudiantesPorParalelo(paraleloId);
    if (!mounted) return;
    setState(() {
      _estudiantesDelParalelo = lista;
      _estudianteDelParalelo = lista.isNotEmpty ? lista.first : null;
      _cargandoParalelo = false;
      if (lista.isEmpty) {
        _errorParalelo = 'No hay estudiantes en este paralelo.';
      }
    });
  }

  Future<void> _cargarTodosLosEstudiantes() async {
    if (_todosLoaded) return;
    setState(() {
      _cargandoTodos = true;
      _errorBusqueda = null;
    });
    final lista = await widget.estudiantesProvider.getAllEstudiantes();
    if (!mounted) return;
    setState(() {
      _todos = lista;
      _todosLoaded = true;
      _cargandoTodos = false;
      if (lista.isEmpty) {
        _errorBusqueda = 'No se encontraron estudiantes.';
      }
    });
  }

  List<EstudianteItem> get _filtrados {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _todos;
    return _todos.where((e) {
      return e.nombreCompleto.toLowerCase().contains(q) ||
          e.codigoEstudiante.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: _buildHeader(),
      content: SizedBox(
        width: 480,
        child: _modo == 0 ? _buildPorParalelo() : _buildBusqueda(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _seleccionado != null
              ? () => Navigator.of(context).pop(_seleccionado)
              : null,
          child: const Text('Generar'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray002855,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Seleccionar Estudiante',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ModeTab(
                label: 'Por Paralelo',
                icon: Icons.groups_outlined,
                selected: _modo == 0,
                onTap: () => setState(() => _modo = 0),
              ),
              const SizedBox(width: 8),
              _ModeTab(
                label: 'Búsqueda',
                icon: Icons.search,
                selected: _modo == 1,
                onTap: () {
                  setState(() => _modo = 1);
                  _cargarTodosLosEstudiantes();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPorParalelo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paralelo',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue1E293B,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButton<ParaleloItem>(
            value: _paraleloSeleccionado,
            isExpanded: true,
            items: widget.paralelos
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text('${p.nombre} — ${_nombreArea(p.areaId)}'),
                  ),
                )
                .toList(),
            onChanged: (p) {
              if (p == null || p.id == _paraleloSeleccionado?.id) return;
              setState(() => _paraleloSeleccionado = p);
              _cargarEstudiantesDelParalelo(p.id);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Estudiante',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue1E293B,
            ),
          ),
          const SizedBox(height: 6),
          if (_cargandoParalelo)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorParalelo != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _errorParalelo!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            )
          else
            DropdownButton<EstudianteItem>(
              value: _estudianteDelParalelo,
              isExpanded: true,
              items: _estudiantesDelParalelo
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        '${e.nombreCompleto} (${e.codigoEstudiante})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (e) => setState(() => _estudianteDelParalelo = e),
            ),
        ],
      ),
    );
  }

  Widget _buildBusqueda() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchCtrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o código...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => _searchCtrl.clear(),
                    )
                  : null,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),
          if (_cargandoTodos)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorBusqueda != null && _todos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _errorBusqueda!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            )
          else ...[
            if (_estudianteBusqueda != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xffDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray002855, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.gray002855, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_estudianteBusqueda!.nombreCompleto} (${_estudianteBusqueda!.codigoEstudiante})',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray002855,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: _filtrados.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          _searchCtrl.text.isEmpty
                              ? 'Escribe para buscar estudiantes'
                              : 'Sin resultados para "${_searchCtrl.text}"',
                          style: TextStyle(
                              color: AppColors.grayMedium, fontSize: 13),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _filtrados.length,
                      separatorBuilder: (_, idx) =>
                          const Divider(height: 1, indent: 12, endIndent: 12),
                      itemBuilder: (_, i) {
                        final e = _filtrados[i];
                        final isSelected =
                            _estudianteBusqueda?.id == e.id;
                        return ListTile(
                          dense: true,
                          selected: isSelected,
                          selectedTileColor:
                              const Color(0xffDBEAFE),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: isSelected
                                ? AppColors.gray002855
                                : const Color(0xffE2E8F0),
                            child: Text(
                              e.nombreCompleto.isNotEmpty
                                  ? e.nombreCompleto[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.darkBlue1E293B,
                              ),
                            ),
                          ),
                          title: Text(
                            e.nombreCompleto,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${e.codigoEstudiante} · ${e.carrera}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.grayMedium,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.gray002855, size: 18)
                              : null,
                          onTap: () =>
                              setState(() => _estudianteBusqueda = e),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pestaña de modo del diálogo unificado.
class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? AppColors.gray002855 : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.gray002855 : Colors.white,
              ),
            ),
          ],
        ),
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
    final screenWidth = MediaQuery.of(context).size.width;
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
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  item.nombre,
                  style: GoogleFonts.inter(
                    color: AppColors.darkBlue1E293B,
                    fontSize: Responsive.titleFontSize(screenWidth) - 2,
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
                    fontSize: Responsive.subtitleFontSize(screenWidth),
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

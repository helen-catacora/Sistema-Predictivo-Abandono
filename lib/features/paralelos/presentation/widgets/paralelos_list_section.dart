import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import 'paralelo_table_row.dart';
import 'paralelos_asignar_encargado_dialog.dart';
import 'paralelos_helpers.dart';

/// Sección "Listado de Paralelos": búsqueda, filtro y tabla.
class ParalelosListSection extends StatefulWidget {
  const ParalelosListSection({super.key});

  @override
  State<ParalelosListSection> createState() => _ParalelosListSectionState();
}

class _ParalelosListSectionState extends State<ParalelosListSection> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ParaleloItem> _filtered(List<ParaleloItem> list) {
    if (_query.trim().isEmpty) return list;
    final q = _query.trim().toLowerCase();
    return list.where((p) {
      return p.nombre.toLowerCase().contains(q) ||
          nombreAreaParalelo(p.areaId).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(color: AppColors.gray002855, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Consumer<ParalelosProvider>(
            builder: (context, provider, _) {
              final list = provider.paralelos;
              final filtered = _filtered(list);
              final isLoading = provider.isLoading;
              final hasError = provider.hasError;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                          'Listado de Paralelos',
                          style: GoogleFonts.inter(
                            color: AppColors.darkBlue1E293B,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: 'Buscar paralelo...',
                              hintStyle: GoogleFonts.inter(
                                color: AppColors.grey94A3B8,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.grey64748B,
                                size: 22,
                              ),
                              filled: true,
                              fillColor: AppColors.greyF8FAFC,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.darkBlue1E293B,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: abrir modal de filtros si se requiere
                          },
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          label: const Text('Filtrar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gray002855,
                            side: BorderSide(color: AppColors.greyE2E8F0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading && list.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Cargando paralelos...'),
                          ],
                        ),
                      ),
                    )
                  else if (hasError && list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        provider.errorMessage ?? 'Error al cargar paralelos',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        _query.trim().isEmpty
                            ? 'No hay paralelos cargados.'
                            : 'No hay resultados para "$_query".',
                        style: GoogleFonts.inter(
                          color: AppColors.grey64748B,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTableHeader(),
                        ...List.generate(
                          filtered.length,
                          (i) => ParaleloTableRow(
                            paralelo: filtered[i],
                            index: i,
                            onAsignarEncargado: () =>
                                _onAsignarEncargado(context, filtered[i]),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.gray002855,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            // flex: 11,
            child: Text(
              'NOMBRE',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // flex: 7,
            child: Text(
              'ÁREA',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // flex: 8,
            child: Text(
              'SEMESTRE',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // flex: 11,
            child: Text(
              'ENCARGADO ACTUAL',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // flex: 8,
            child: Text(
              'ACCIÓN',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAsignarEncargado(BuildContext context, ParaleloItem paralelo) {
    showAsignarEncargadoDialog(context, paralelo: paralelo);
  }
}

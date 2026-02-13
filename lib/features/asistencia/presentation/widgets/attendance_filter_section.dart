import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/materia_item.dart';
import '../../data/models/paralelo_item.dart';
import '../providers/asistencias_provider.dart';
import '../providers/materias_provider.dart';
import '../providers/paralelos_provider.dart';

/// Sección de filtros para el registro de asistencia.
class AttendanceFilterSection extends StatefulWidget {
  const AttendanceFilterSection({super.key});

  @override
  State<AttendanceFilterSection> createState() =>
      _AttendanceFilterSectionState();
}

class _AttendanceFilterSectionState extends State<AttendanceFilterSection> {
  int? _selectedParaleloId;
  int? _selectedMateriaId;

  @override
  Widget build(BuildContext context) {
    return Consumer3<ParalelosProvider, MateriasProvider, AsistenciasProvider>(
      builder:
          (
            context,
            paralelosProvider,
            materiasProvider,
            asistenciasProvider,
            child,
          ) {
            final paralelos = paralelosProvider.paralelos;
            ParaleloItem? paraleloSeleccionado;
            if (_selectedParaleloId != null) {
              for (final p in paralelos) {
                if (p.id == _selectedParaleloId) {
                  paraleloSeleccionado = p;
                  break;
                }
              }
            }

            if (_selectedParaleloId == null && paralelos.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedParaleloId = paralelos.first.id;
                  _selectedMateriaId = null;
                });
              });
            }

            final materiasFiltradas = paraleloSeleccionado != null
                ? materiasProvider.materiasPorAreaYSemestre(
                    paraleloSeleccionado.areaId,
                    paraleloSeleccionado.semestreId,
                  )
                : <MateriaItem>[];

            if (_selectedMateriaId != null &&
                !materiasFiltradas.any((m) => m.id == _selectedMateriaId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _selectedMateriaId = null);
              });
            }

            if (_selectedMateriaId == null &&
                materiasFiltradas.isNotEmpty &&
                _selectedParaleloId != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _selectedMateriaId = materiasFiltradas.first.id);
              });
            }

            return Card(
              elevation: 0,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PARALELO',
                            style: GoogleFonts.inter(
                              color: AppColors.grey64748B,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            initialValue: paralelos.isEmpty
                                ? null
                                : (_selectedParaleloId ?? paralelos.first.id),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              fillColor: Color(0xffF8FAFC),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                            items: _buildParaleloItems(
                              paralelos,
                              paralelosProvider.isLoading,
                            ),
                            onChanged: paralelosProvider.isLoading
                                ? null
                                : (value) => setState(() {
                                    _selectedParaleloId = value;
                                    _selectedMateriaId = null;
                                  }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MATERIA',
                            style: GoogleFonts.inter(
                              color: AppColors.grey64748B,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            initialValue: materiasFiltradas.isEmpty
                                ? null
                                : (_selectedMateriaId ??
                                      (materiasFiltradas.isNotEmpty
                                          ? materiasFiltradas.first.id
                                          : null)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              fillColor: Color(0xffF8FAFC),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                            items: _buildMateriaItems(
                              materiasFiltradas,
                              materiasProvider.isLoading,
                              paraleloSeleccionado != null,
                            ),
                            onChanged:
                                materiasProvider.isLoading ||
                                    paraleloSeleccionado == null
                                ? null
                                : (value) => setState(
                                    () => _selectedMateriaId = value,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FECHA',
                            style: GoogleFonts.inter(
                              color: AppColors.grey64748B,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'dd/mm/aaaa',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xffE2E8F0),
                                  width: 1,
                                ),
                              ),
                              fillColor: Color(0xffF8FAFC),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    FilledButton.icon(
                      onPressed:
                          _selectedMateriaId != null &&
                              _selectedParaleloId != null
                          ? () {
                              asistenciasProvider.loadAsistenciasDia(
                                materiaId: _selectedMateriaId!,
                                paraleloId: _selectedParaleloId!,
                              );
                            }
                          : null,
                      icon: asistenciasProvider.isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.filter_list, size: 18),
                      label: Text(
                        asistenciasProvider.isLoading
                            ? 'Cargando...'
                            : 'Aplicar Filtros',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navyMedium,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }

  List<DropdownMenuItem<int>> _buildParaleloItems(
    List<ParaleloItem> paralelos,
    bool isLoading,
  ) {
    if (paralelos.isEmpty) {
      return [
        DropdownMenuItem<int>(
          value: null,
          child: Text(
            isLoading ? 'Cargando...' : 'Sin paralelos',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ];
    }
    return paralelos
        .map(
          (p) => DropdownMenuItem<int>(
            value: p.id,
            child: Text('${p.nombre} - ${_nombreArea(p.areaId)}'),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<int>> _buildMateriaItems(
    List<MateriaItem> materias,
    bool isLoading,
    bool paraleloSeleccionado,
  ) {
    if (!paraleloSeleccionado) {
      return [
        DropdownMenuItem<int>(
          value: null,
          child: Text(
            'Seleccione un paralelo',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ];
    }
    if (materias.isEmpty) {
      return [
        DropdownMenuItem<int>(
          value: null,
          child: Text(
            isLoading ? 'Cargando...' : 'Sin materias',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ];
    }
    return materias
        .map((m) => DropdownMenuItem<int>(value: m.id, child: Text(m.nombre)))
        .toList();
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
}

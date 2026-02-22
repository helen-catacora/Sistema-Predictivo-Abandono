import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../providers/estudiantes_provider.dart';

/// Sección de búsqueda y filtros para estudiantes.
class StudentFilterSection extends StatefulWidget {
  const StudentFilterSection({super.key});

  @override
  State<StudentFilterSection> createState() => _StudentFilterSectionState();
}

class _StudentFilterSectionState extends State<StudentFilterSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EstudiantesProvider, ParalelosProvider>(
      builder: (context, provider, paralelosProvider, _) {
        final paralelos = paralelosProvider.paralelos;
        final carreraFilter = provider.carreraFilter;
        final paralelosVisibles =
            carreraFilter == null ||
                carreraFilter.isEmpty ||
                carreraFilter == 'todas'
            ? paralelos
            : paralelos.where((p) {
                final areaStr = p.areaNombre ?? _nombreArea(p.areaId);
                return areaStr == carreraFilter;
              }).toList();
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
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BUSCAR ESTUDIANTE',
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
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Nombre, ID o correo electrónico...',
                          hintStyle: GoogleFonts.inter(
                            color: AppColors.gray9CA3AF,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: 0,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20),
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
                          border: OutlineInputBorder(
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
                        onChanged: (value) => provider.setSearchQuery(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
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
                      DropdownButtonFormField<int?>(
                        initialValue:
                            paralelosVisibles.any(
                              (p) => p.id == provider.paraleloFilter,
                            )
                            ? provider.paraleloFilter
                            : null,
                        decoration: InputDecoration(
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
                          border: OutlineInputBorder(
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
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(
                              paralelosProvider.isLoading && paralelos.isEmpty
                                  ? 'Cargando paralelos...'
                                  : 'Todos los paralelos',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkBlue1E293B,
                                height: 20 / 14,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          ...paralelosVisibles.map(
                            (p) => DropdownMenuItem<int?>(
                              value: p.id,
                              child: Text(
                                '${p.nombre}-${p.areaNombre ?? _nombreArea(p.areaId)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkBlue1E293B,
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          provider.setParaleloFilter(value);
                          provider.loadEstudiantes();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARRERA',
                        style: GoogleFonts.inter(
                          color: AppColors.grey64748B,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 16 / 12,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: provider.carreraFilter ?? 'todas',
                        decoration: InputDecoration(
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
                          border: OutlineInputBorder(
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
                        items: [
                          DropdownMenuItem(
                            value: 'todas',
                            child: Text(
                              'Todas las Carreras',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkBlue1E293B,
                                height: 20 / 14,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          ...provider.carreras.map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkBlue1E293B,
                                  height: 20 / 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          provider.setCarreraFilter(value);
                          final nuevaCarrera =
                              (value == null || value == 'todas')
                              ? null
                              : value;
                          final listaPorCarrera = nuevaCarrera == null
                              ? paralelos
                              : paralelos
                                    .where(
                                      (p) =>
                                          (p.areaNombre ??
                                              _nombreArea(p.areaId)) ==
                                          nuevaCarrera,
                                    )
                                    .toList();
                          if (provider.paraleloFilter != null &&
                              !listaPorCarrera.any(
                                (p) => p.id == provider.paraleloFilter,
                              )) {
                            provider.setParaleloFilter(null);
                            provider.loadEstudiantes();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    provider.setSearchQuery('');
                    provider.setCarreraFilter(null);
                    provider.setParaleloFilter(null);
                    provider.loadEstudiantes();
                  },
                  icon: const Icon(Icons.tune, size: 20),
                  label: const Text('Limpiar filtros'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.blueLight,
                    foregroundColor: AppColors.navyMedium,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  static String _nombreArea(int areaId) {
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

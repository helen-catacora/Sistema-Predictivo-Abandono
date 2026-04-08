import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/usuarios_provider.dart';

/// Roles disponibles para filtro.
const List<String> _rolesDisponibles = [
  'Super Administrador',
  'Administrador',
  'Encargado de Curso',
];

/// Barra de búsqueda y filtros para usuarios.
class UsersFilterBar extends StatefulWidget {
  const UsersFilterBar({super.key});

  @override
  State<UsersFilterBar> createState() => _UsersFilterBarState();
}

class _UsersFilterBarState extends State<UsersFilterBar> {
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
    return Consumer<UsuariosProvider>(
      builder: (context, provider, _) {
        return Card(
          elevation: 0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

                final searchField = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUSCAR USUARIO',
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
                        hintText: 'Nombre, correo o cargo...',
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
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        fillColor: const Color(0xffF8FAFC),
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
                );

                final rolField = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROL',
                      style: GoogleFonts.inter(
                        color: AppColors.grey64748B,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 16 / 12,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      initialValue: provider.rolFilter,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        fillColor: const Color(0xffF8FAFC),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'Todos los roles',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkBlue1E293B,
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        ..._rolesDisponibles.map(
                          (r) => DropdownMenuItem<String?>(
                            value: r,
                            child: Text(
                              r,
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
                      onChanged: (value) => provider.setRolFilter(value),
                    ),
                  ],
                );

                final estadoField = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTADO',
                      style: GoogleFonts.inter(
                        color: AppColors.grey64748B,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 16 / 12,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      initialValue: provider.estadoFilter,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xffE2E8F0),
                          ),
                        ),
                        fillColor: const Color(0xffF8FAFC),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'Todos los estados',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkBlue1E293B,
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'activo',
                          child: Text(
                            'Activo',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkBlue1E293B,
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'inactivo',
                          child: Text(
                            'Inactivo',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkBlue1E293B,
                              height: 20 / 14,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) => provider.setEstadoFilter(value),
                    ),
                  ],
                );

                final clearButton = OutlinedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    provider.clearFilters();
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
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      searchField,
                      const SizedBox(height: 12),
                      rolField,
                      const SizedBox(height: 12),
                      estadoField,
                      const SizedBox(height: 12),
                      clearButton,
                    ],
                  );
                }

                if (isTablet) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 3, child: searchField),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: rolField),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(flex: 2, child: estadoField),
                          const SizedBox(width: 16),
                          clearButton,
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(flex: 2, child: searchField),
                    const SizedBox(width: 24),
                    Expanded(child: rolField),
                    const SizedBox(width: 24),
                    Expanded(child: estadoField),
                    const SizedBox(width: 24),
                    clearButton,
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

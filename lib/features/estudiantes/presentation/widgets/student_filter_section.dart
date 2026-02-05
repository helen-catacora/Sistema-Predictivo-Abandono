import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
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
    return Consumer<EstudiantesProvider>(
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
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BUSCAR ESTUDIANTE',
                        style: TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Nombre, ID o correo electrónico...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        onChanged: (value) =>
                            provider.setSearchQuery(value),
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
                        'FACULTAD / CARRERA',
                        style: TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: provider.carreraFilter ?? 'todas',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'todas',
                            child: Text('Todas las Carreras'),
                          ),
                          ...provider.carreras.map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            provider.setCarreraFilter(value),
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
                  },
                  icon: const Icon(Icons.tune, size: 20),
                  label: const Text('Limpiar filtros'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.blueLight,
                    foregroundColor: AppColors.navyMedium,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
}

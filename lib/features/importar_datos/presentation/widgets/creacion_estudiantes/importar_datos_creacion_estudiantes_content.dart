import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../import_section_header.dart';
import 'creacion_estudiantes_file_selector.dart';
import 'creacion_estudiantes_historial_table.dart';
import 'creacion_estudiantes_instructions_card.dart';
import 'creacion_estudiantes_sidebar.dart';

/// Contenido completo de la pantalla "Importar Datos para Creación de Estudiantes".
class ImportarDatosCreacionEstudiantesContent extends StatelessWidget {
  const ImportarDatosCreacionEstudiantesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final useRow = constraints.maxWidth > 900;
              if (useRow) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLeftColumn(context),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: CreacionEstudiantesSidebar(),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  _buildLeftColumn(context),
                  const SizedBox(height: 24),
                  CreacionEstudiantesSidebar(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Importar Datos para Creación de Estudiantes',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'CARGUE ARCHIVOS CON INFORMACIÓN PARA REGISTRAR NUEVOS ESTUDIANTES',
            style: TextStyle(
              color: AppColors.grayMedium,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CreacionEstudiantesInstructionsCard(),
        const SizedBox(height: 32),
        const ImportSectionHeader(title: 'Seleccionar Archivo'),
        const SizedBox(height: 16),
        const CreacionEstudiantesFileSelector(),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ImportSectionHeader(title: 'Historial de Importaciones'),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filtrar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CreacionEstudiantesHistorialTable(),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/creacion_estudiantes/importar_datos_creacion_estudiantes_content.dart';
import '../widgets/import_file_selector.dart';
import '../widgets/import_history_table.dart';
import '../widgets/import_main_section.dart';
import '../widgets/import_page_header.dart';
import '../widgets/import_section_header.dart';

/// Tipo de vista en la página Importar Datos.
enum ImportarDatosVista {
  prediccionMasiva,
  creacionEstudiantes,
}

/// Pantalla Importar Datos con menú flotante para alternar entre Predicción masiva y Creación de estudiantes.
class ImportarDatosPage extends StatefulWidget {
  const ImportarDatosPage({super.key});

  @override
  State<ImportarDatosPage> createState() => _ImportarDatosPageState();
}

class _ImportarDatosPageState extends State<ImportarDatosPage> {
  ImportarDatosVista _vistaActual = ImportarDatosVista.prediccionMasiva;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMenuFlotante(),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: _vistaActual == ImportarDatosVista.prediccionMasiva
                ? _buildContenidoPrediccionMasiva()
                : const ImportarDatosCreacionEstudiantesContent(),
          ),
        ),
      ],
    );
  }

  /// Menú flotante en la parte superior para cambiar entre vistas.
  Widget _buildMenuFlotante() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              label: 'Predicción masiva',
              icon: Icons.analytics_outlined,
              selected: _vistaActual == ImportarDatosVista.prediccionMasiva,
              onTap: () =>
                  setState(() => _vistaActual = ImportarDatosVista.prediccionMasiva),
            ),
            const SizedBox(width: 8),
            _menuItem(
              label: 'Creación de estudiantes',
              icon: Icons.person_add_outlined,
              selected: _vistaActual == ImportarDatosVista.creacionEstudiantes,
              onTap: () => setState(
                  () => _vistaActual = ImportarDatosVista.creacionEstudiantes),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.navyMedium : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? AppColors.white : AppColors.grayDark,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.grayDark,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContenidoPrediccionMasiva() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ImportPageHeader(),
        const SizedBox(height: 32),
        const ImportMainSection(),
        const SizedBox(height: 32),
        const ImportSectionHeader(title: 'Seleccionar Archivo'),
        const SizedBox(height: 16),
        const ImportFileSelector(),
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
        const ImportHistoryTable(),
      ],
    );
  }
}

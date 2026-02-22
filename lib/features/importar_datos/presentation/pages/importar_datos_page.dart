import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../widgets/import_file_selector.dart';
import '../widgets/import_main_section.dart';
import '../widgets/import_page_header.dart';

/// Tipo de vista en la página Importar Datos.
enum ImportarDatosVista { prediccionMasiva, creacionEstudiantes }

/// Pantalla Importar Datos con menú flotante para alternar entre Predicción masiva y Creación de estudiantes.
class ImportarDatosPage extends StatefulWidget {
  const ImportarDatosPage({super.key});

  @override
  State<ImportarDatosPage> createState() => _ImportarDatosPageState();
}

class _ImportarDatosPageState extends State<ImportarDatosPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const ScreenDescriptionCard(
        //   description:
        //       'Cargue archivos Excel con información estudiantil para predicción masiva o para la creación de estudiantes en el sistema.',
        //   icon: Icons.file_download_outlined,
        // ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: _buildContenidoPrediccionMasiva(),
            // child: _vistaActual == ImportarDatosVista.prediccionMasiva
            //     ? _buildContenidoPrediccionMasiva()
            //     : const ImportarDatosCreacionEstudiantesPage(),
          ),
        ),
      ],
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
        const SizedBox(height: 16),
        const ImportFileSelector(),
        const SizedBox(height: 32),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     OutlinedButton.icon(
        //       onPressed: () {},
        //       icon: const Icon(Icons.filter_list, size: 18),
        //       label: const Text('Filtrar'),
        //       style: OutlinedButton.styleFrom(
        //         foregroundColor: Colors.grey.shade700,
        //         side: BorderSide(color: Colors.grey.shade300),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 16),
        //const ImportHistoryTable(),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/import_file_selector.dart';
import '../widgets/import_history_table.dart';
import '../widgets/import_main_section.dart';
import '../widgets/import_page_header.dart';
import '../widgets/import_section_header.dart';

/// Pantalla Importar Datos.
class ImportarDatosPage extends StatelessWidget {
  const ImportarDatosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ImportPageHeader(),
          const SizedBox(height: 32),
          const ImportMainSection(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ImportSectionHeader(title: 'Seleccionar Archivo'),
            ],
          ),
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
      ),
    );
  }
}

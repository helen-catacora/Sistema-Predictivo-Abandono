import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/importar_estudiantes_provider.dart';

/// Extensiones permitidas para importación de estudiantes (el backend solo acepta .xlsx).
const List<String> _extensionesXlsx = ['xlsx'];

/// Área de selección de archivo para creación de estudiantes (Excel .xlsx).
class CreacionEstudiantesFileSelector extends StatefulWidget {
  const CreacionEstudiantesFileSelector({super.key});

  @override
  State<CreacionEstudiantesFileSelector> createState() =>
      _CreacionEstudiantesFileSelectorState();
}

class _CreacionEstudiantesFileSelectorState
    extends State<CreacionEstudiantesFileSelector> {
  bool _isDragging = false;
  PlatformFile? _selectedFile;

  bool _canImport(PlatformFile? file) =>
      file != null &&
      _extensionesXlsx.any(
          (e) => file.name.toLowerCase().endsWith('.$e'));

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportarEstudiantesProvider>(
      builder: (context, provider, _) {
        final isImporting = provider.isImporting;
        final canImport = _canImport(_selectedFile);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (provider.errorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => provider.clearError(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            MouseRegion(
              onEnter: (_) => setState(() => _isDragging = true),
              onExit: (_) => setState(() => _isDragging = false),
              child: GestureDetector(
                onTap: _selectFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      vertical: 48, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? AppColors.blueLight
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDragging
                          ? AppColors.navyMedium
                          : Colors.grey.shade400,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 64,
                        color: _isDragging
                            ? AppColors.navyMedium
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedFile?.name ??
                            'Arrastre su archivo aquí o haga clic para seleccionar desde su computadora',
                        style: TextStyle(
                          color: AppColors.navyMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: _selectFile,
                        icon: const Icon(Icons.folder_open, size: 20),
                        label: const Text('EXPLORAR ARCHIVOS'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navyMedium,
                          side: const BorderSide(color: AppColors.navyMedium),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Formatos aceptados: XLSX | Tamaño máximo: 10MB',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: isImporting
                      ? null
                      : () => setState(() => _selectedFile = null),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('CANCELAR'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.grayDark,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: (canImport && !isImporting)
                      ? () => _iniciarImportacion(context)
                      : null,
                  icon: isImporting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.upload, size: 18),
                  label: Text(
                      isImporting ? 'IMPORTANDO...' : 'INICIAR IMPORTACIÓN'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _extensionesXlsx,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.single);
    }
  }

  Future<void> _iniciarImportacion(BuildContext context) async {
    if (_selectedFile == null || !_canImport(_selectedFile)) return;
    final provider = context.read<ImportarEstudiantesProvider>();

    final response = await provider.enviarArchivo(_selectedFile!);
    if (!context.mounted) return;

    if (response != null) {
      setState(() => _selectedFile = null);
      final msg = StringBuffer('Importación completada. ');
      msg.write('Creados: ${response.estudiantesCreados}, ');
      msg.write('Actualizados: ${response.estudiantesActualizados}');
      if (response.totalErrores > 0) {
        msg.write(', Errores: ${response.totalErrores}');
      }
      msg.write('.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg.toString())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al importar'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}

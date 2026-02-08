import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/importar_predicciones_provider.dart';

/// Extensiones permitidas para predicción masiva (solo Excel).
const List<String> _extensionesExcel = ['xlsx', 'xls'];

/// Área de arrastrar y soltar para seleccionar archivo y enviar a POST /predicciones/masiva.
class ImportFileSelector extends StatefulWidget {
  const ImportFileSelector({super.key});

  @override
  State<ImportFileSelector> createState() => _ImportFileSelectorState();
}

class _ImportFileSelectorState extends State<ImportFileSelector> {
  bool _isDragging = false;
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportarPrediccionesProvider>(
      builder: (context, provider, _) {
        final isImporting = provider.isImporting;
        final fileName = _selectedFile?.name;
        final canImport = _selectedFile != null &&
            _extensionesExcel.any((e) =>
                fileName!.toLowerCase().endsWith('.$e'));

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
                          onPressed: () {
                            provider.clearError();
                          },
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
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _isDragging ? AppColors.blueLight : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _isDragging ? AppColors.navyMedium : Colors.grey.shade300,
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
                        fileName ?? 'Arrastre su archivo Excel aquí',
                        style: TextStyle(
                          color: AppColors.navyMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileName != null
                            ? ''
                            : 'o haga clic para seleccionar (solo .xlsx o .xls)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: _selectFile,
                        icon: const Icon(Icons.folder_open, size: 20),
                        label: const Text('EXPLORAR ARCHIVOS'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navyMedium,
                          side: const BorderSide(color: AppColors.navyMedium),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Formato aceptado: XLSX, XLS (predicción masiva)',
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
                  onPressed: (canImport && !isImporting) ? () => _startImport(context) : null,
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
                  label: Text(isImporting ? 'IMPORTANDO...' : 'INICIAR IMPORTACIÓN'),
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
      allowedExtensions: _extensionesExcel,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.single);
    }
  }

  Future<void> _startImport(BuildContext context) async {
    if (_selectedFile == null) return;
    final provider = context.read<ImportarPrediccionesProvider>();

    if (!_extensionesExcel.any((e) =>
        _selectedFile!.name.toLowerCase().endsWith('.$e'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un archivo Excel (.xlsx o .xls)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final ok = await provider.enviarArchivo(_selectedFile!);
    if (!context.mounted) return;
    if (ok) {
      setState(() => _selectedFile = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Importación completada correctamente')),
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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Área de arrastrar y soltar para seleccionar archivo.
class ImportFileSelector extends StatefulWidget {
  const ImportFileSelector({super.key});

  @override
  State<ImportFileSelector> createState() => _ImportFileSelectorState();
}

class _ImportFileSelectorState extends State<ImportFileSelector> {
  bool _isDragging = false;
  String? _selectedFileName;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                    _selectedFileName ?? 'Arrastre su archivo aquí',
                    style: TextStyle(
                      color: AppColors.navyMedium,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedFileName != null
                        ? ''
                        : 'o haga clic para seleccionar desde su computadora',
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
                    'Formatos aceptados: CSV, XLSX, JSON | Tamaño máximo: 10MB',
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
              onPressed: () => setState(() => _selectedFileName = null),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('CANCELAR'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.grayDark,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _selectedFileName != null && !_isImporting
                  ? _startImport
                  : null,
              icon: _isImporting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.upload, size: 18),
              label: Text(_isImporting ? 'IMPORTANDO...' : 'INICIAR IMPORTACIÓN'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navyMedium,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls', 'json'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFileName = result.files.single.name);
    }
  }

  Future<void> _startImport() async {
    if (_selectedFileName == null) return;
    setState(() => _isImporting = true);
    // Simular proceso de importación (conectar con backend después)
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isImporting = false;
        _selectedFileName = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Importación completada')),
      );
    }
  }
}

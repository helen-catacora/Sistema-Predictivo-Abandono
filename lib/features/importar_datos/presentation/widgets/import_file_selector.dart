import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/importar_datos/presentation/widgets/import_summary_cards.dart';

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
        final canImport =
            _selectedFile != null &&
            _extensionesExcel.any(
              (e) => fileName!.toLowerCase().endsWith('.$e'),
            );

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(color: Color(0xff002855), width: 4),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xff002855),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Seleccionar Archivo',
                              style: TextStyle(
                                color: Color(0xff1E293B),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 28 / 10,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        MouseRegion(
                          onEnter: (_) => setState(() => _isDragging = true),
                          onExit: (_) => setState(() => _isDragging = false),
                          child: GestureDetector(
                            onTap: _selectFile,
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(12),
                                dashPattern: [10, 5],
                                strokeWidth: 2,
                                color: _isDragging
                                    ? AppColors.navyMedium
                                    : Colors.grey,
                              ),
                              child: AnimatedContainer(
                                width: double.infinity,
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 48,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: _isDragging
                                      ? AppColors.blueLight
                                      : Colors.grey.shade50,
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
                                      fileName ??
                                          'Arrastre su archivo Excel aquí',
                                      style: GoogleFonts.inter(
                                        color: Color(0xff334155),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 28 / 18,
                                        letterSpacing: 0,
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
                                    GestureDetector(
                                      onTap: _selectFile,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xff002855),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.folder_open,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'EXPLORAR ARCHIVOS',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                height: 20 / 14,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ],
                                        ),
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
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: isImporting
                                  ? null
                                  : () => setState(() => _selectedFile = null),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffCBD5E1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.refresh, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'CANCELAR',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Color(0xff334155),
                                        fontWeight: FontWeight.w700,
                                        height: 20 / 14,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: (canImport && !isImporting)
                                  ? () => _startImport(context)
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff002855),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.upload,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      isImporting
                                          ? 'IMPORTANDO...'
                                          : 'INICIAR IMPORTACIÓN',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        height: 20 / 14,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(flex: 1, child: const RequiredFieldsCard()),
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

    if (!_extensionesExcel.any(
      (e) => _selectedFile!.name.toLowerCase().endsWith('.$e'),
    )) {
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

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/importar_malla_curricular_provider.dart';

const List<String> _extensionesXlsx = ['xlsx'];

/// Área de selección de archivo y nombre de malla para importación de malla curricular.
class MallaCurricularFileSelector extends StatefulWidget {
  const MallaCurricularFileSelector({super.key});

  @override
  State<MallaCurricularFileSelector> createState() =>
      _MallaCurricularFileSelectorState();
}

class _MallaCurricularFileSelectorState extends State<MallaCurricularFileSelector> {
  bool _isDragging = false;
  PlatformFile? _selectedFile;
  final TextEditingController _nombreMallaController = TextEditingController();

  bool _canImport(PlatformFile? file) =>
      file != null &&
      _extensionesXlsx.any((e) => file.name.toLowerCase().endsWith('.$e'));

  @override
  void dispose() {
    _nombreMallaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportarMallaCurricularProvider>(
      builder: (context, provider, _) {
        final isImporting = provider.isImporting;
        final nombreMalla = _nombreMallaController.text.trim();
        final canImport = _canImport(_selectedFile) && nombreMalla.isNotEmpty;

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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  top: BorderSide(color: Color(0xff002855), width: 4),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xff002855),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nombre de Malla Curricular',
                        style: GoogleFonts.inter(
                          color: Color(0xff1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 28 / 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nombreMallaController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Ej. Competencias 2024-2028',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xff002855),
                          width: 1.5,
                        ),
                      ),
                      fillColor: const Color(0xffF8FAFC),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xff002855),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Seleccionar Archivo',
                        style: GoogleFonts.inter(
                          color: Color(0xff1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 28 / 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isDragging = true),
                    onExit: (_) => setState(() => _isDragging = false),
                    child: GestureDetector(
                      onTap: _selectFile,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(12),
                          dashPattern: const [10, 5],
                          strokeWidth: 2,
                          color: _isDragging ? AppColors.navyMedium : Colors.grey,
                        ),
                        child: AnimatedContainer(
                          width: double.infinity,
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 48,
                            horizontal: 24,
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
                                    'Arrastre su archivo aquí o haga clic para seleccionar',
                                style: const TextStyle(
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
                                  side: const BorderSide(
                                    color: AppColors.navyMedium,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Formato aceptado: XLSX | Tamaño máximo: 10MB',
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffCBD5E1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.refresh, size: 18),
                              const SizedBox(width: 8),
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
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: (canImport && !isImporting)
                            ? () => _iniciarImportacion(context)
                            : null,
                        child: Opacity(
                          opacity: (canImport && !isImporting) ? 1 : 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff002855),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.upload,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
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
                      ),
                    ],
                  ),
                ],
              ),
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
    final nombreMalla = _nombreMallaController.text.trim();
    if (nombreMalla.isEmpty) return;

    final provider = context.read<ImportarMallaCurricularProvider>();

    final response = await provider.enviarArchivo(
      file: _selectedFile!,
      nombreMalla: nombreMalla,
    );
    if (!context.mounted) return;

    if (response != null) {
      setState(() => _selectedFile = null);
      final msg = StringBuffer('Importación completada. ');
      msg.write('Registros creados: ${response.registrosCreados}, ');
      msg.write('Materias creadas: ${response.materiasCreadas}');
      if (response.yaExistentes > 0) {
        msg.write(', Ya existentes: ${response.yaExistentes}');
      }
      if (response.errores.isNotEmpty) {
        msg.write(', Errores: ${response.errores.length}');
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

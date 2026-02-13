import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/importar_datos/presentation/widgets/creacion_estudiantes/creacion_estudiantes_sidebar.dart';

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
  static const _requiredFields = [
    'ID Estudiante',
    'Nombres Completos',
    'Apellidos',
    'Email Institucional',
    'Teléfono',
    'Dirección',
    'Semestre / Nivel',
  ];

  static const _optionalFields = [
    'Fecha de Nacimiento',
    'Carrera',
    'Contacto de Emergencia',
  ];

  bool _isDragging = false;
  PlatformFile? _selectedFile;

  bool _canImport(PlatformFile? file) =>
      file != null &&
      _extensionesXlsx.any((e) => file.name.toLowerCase().endsWith('.$e'));

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
                                      icon: const Icon(
                                        Icons.folder_open,
                                        size: 20,
                                      ),
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
                                  ? () => _iniciarImportacion(context)
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
                SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: RequiredOptionalFieldsCard(
                    requiredFields: _requiredFields,
                    optionalFields: _optionalFields,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg.toString())));
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

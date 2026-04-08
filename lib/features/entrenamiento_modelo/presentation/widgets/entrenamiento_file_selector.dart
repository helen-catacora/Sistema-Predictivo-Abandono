import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/entrenamiento_provider.dart';

/// Selector de archivo para entrenamiento — estilo DottedBorder.
class EntrenamientoFileSelector extends StatefulWidget {
  const EntrenamientoFileSelector({super.key});

  @override
  State<EntrenamientoFileSelector> createState() =>
      _EntrenamientoFileSelectorState();
}

class _EntrenamientoFileSelectorState extends State<EntrenamientoFileSelector> {
  bool _isDragging = false;
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Consumer<EntrenamientoProvider>(
      builder: (context, provider, _) {
        final isTraining = provider.isTraining;
        final fileName = _selectedFile?.name;
        final canStart = _selectedFile != null && !isTraining;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  top: BorderSide(color: Color(0xff002855), width: 4),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                children: [
                  // Section header con barra vertical
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
                        'Seleccionar Archivo de Entrenamiento',
                        style: GoogleFonts.inter(
                          color: const Color(0xff1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 28 / 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'El archivo Excel debe contener 15 features + columna "Abandono" (si/no). Mínimo 50 registros.',
                      style: GoogleFonts.inter(
                        color: const Color(0xff64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Zona de arrastrar/soltar
                  MouseRegion(
                    onEnter: (_) => setState(() => _isDragging = true),
                    onExit: (_) => setState(() => _isDragging = false),
                    child: GestureDetector(
                      onTap: isTraining ? null : _selectFile,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(12),
                          dashPattern: const [10, 5],
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
                                fileName != null
                                    ? Icons.check_circle_outline
                                    : Icons.cloud_upload_outlined,
                                size: 64,
                                color: fileName != null
                                    ? AppColors.green16A34A
                                    : _isDragging
                                        ? AppColors.navyMedium
                                        : Colors.grey.shade600,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                fileName ??
                                    'Arrastre su archivo Excel aquí',
                                style: GoogleFonts.inter(
                                  color: fileName != null
                                      ? AppColors.green16A34A
                                      : const Color(0xff334155),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 28 / 18,
                                  letterSpacing: 0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              if (fileName != null)
                                Text(
                                  '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                )
                              else
                                Text(
                                  'o haga clic para seleccionar (solo .xlsx)',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: isTraining ? null : _selectFile,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff002855),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
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
                                      const SizedBox(width: 8),
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
                                'Formato aceptado: XLSX (entrenamiento del modelo)',
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

                  // Botones CANCELAR + INICIAR ENTRENAMIENTO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: isTraining
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
                                  color: const Color(0xff334155),
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
                        onTap: canStart
                            ? () => _iniciarEntrenamiento(context)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: canStart
                                ? const Color(0xff002855)
                                : const Color(0xff002855).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isTraining
                                    ? Icons.hourglass_top
                                    : Icons.model_training,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isTraining
                                    ? 'ENTRENANDO...'
                                    : 'INICIAR ENTRENAMIENTO',
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
          ],
        );
      },
    );
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.single);
    }
  }

  Future<void> _iniciarEntrenamiento(BuildContext context) async {
    if (_selectedFile == null) return;
    final provider = context.read<EntrenamientoProvider>();
    final ok = await provider.iniciarEntrenamiento(_selectedFile!);
    if (!context.mounted) return;
    if (ok) {
      setState(() => _selectedFile = null);
    }
  }
}

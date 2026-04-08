import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/utils/excel_download_web.dart'
    if (dart.library.io) '../../../../shared/utils/excel_download_stub.dart'
    as excel_util;
import '../providers/entrenamiento_provider.dart';

/// Panel con instrucciones de entrenamiento — estilo gradiente navy.
class EntrenamientoInstructionsPanel extends StatefulWidget {
  const EntrenamientoInstructionsPanel({super.key});

  @override
  State<EntrenamientoInstructionsPanel> createState() =>
      _EntrenamientoInstructionsPanelState();
}

class _EntrenamientoInstructionsPanelState
    extends State<EntrenamientoInstructionsPanel> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF002855), Color(0xFF023E8A)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffFFD60A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.model_training,
                  color: AppColors.navyDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instrucciones de Entrenamiento',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 28 / 20,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Siga estos pasos para entrenar o reentrenar el modelo predictivo',
                      style: GoogleFonts.inter(
                        color: const Color(0xffDBEAFE),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStep(
            '1',
            'Descargar Plantilla:',
            'Descargue la plantilla Excel con las 16 columnas requeridas (15 features + Abandono).',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '2',
            'Completar Datos:',
            'Llene los datos estudiantiles. Mínimo 50 registros. Columna "Abandono" con valores si/no.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '3',
            'Subir y Entrenar:',
            'El sistema entrenará 3 modelos (Random Forest, XGBoost, Logistic Regression) y seleccionará el mejor.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '4',
            'Comparar y Decidir:',
            'Compare las métricas del nuevo modelo con el actual y decida si desea reemplazarlo.',
          ),
          const SizedBox(height: 32),
          SizedBox(
            child: FilledButton.icon(
              onPressed: _isDownloading ? null : _descargarPlantilla,
              icon: _isDownloading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff002855),
                      ),
                    )
                  : const Icon(
                      Icons.download,
                      size: 20,
                      color: Color(0xff002855),
                    ),
              label: Text(
                'DESCARGAR PLANTILLA',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xff002855),
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: const Color(0xffFFD60A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 24 / 16,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: GoogleFonts.inter(
                  color: const Color(0xffDBEAFE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _descargarPlantilla() async {
    setState(() => _isDownloading = true);
    try {
      final provider = context.read<EntrenamientoProvider>();
      final bytes = await provider.descargarPlantilla();
      if (bytes != null) {
        final path = excel_util.saveExcel(
          Uint8List.fromList(bytes),
          'plantilla_entrenamiento.xlsx',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(path != null
                  ? 'Plantilla guardada en: $path'
                  : 'Plantilla descargada correctamente'),
              backgroundColor: AppColors.green16A34A,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar: $e'),
            backgroundColor: AppColors.redDC2626,
          ),
        );
      }
    }
    setState(() => _isDownloading = false);
  }
}

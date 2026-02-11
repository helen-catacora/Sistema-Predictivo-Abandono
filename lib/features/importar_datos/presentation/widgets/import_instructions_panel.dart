import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Panel lateral con instrucciones de importación.
class ImportInstructionsPanel extends StatelessWidget {
  const ImportInstructionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
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
                  color: Color(0xffFFD60A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.navyDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instrucciones de Importación',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 28 / 20,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Siga estos pasos para asegurar una correcta importación de datos',
                    style: GoogleFonts.inter(
                      color: Color(0xffDBEAFE),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStep(
            '1',
            'Formato de Archivo:',
            'Use archivos CSV, Excel (.xlsx) o JSON. Máximo 10MB por archivo.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '2',
            'Campos Requeridos:',
            'ID Estudiante, Nombres, Apellidos, Semestre, Promedio, Asistencia (%).',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '3',
            'Validación Automática:',
            'El sistema validará los datos y mostrará errores antes de procesarlos.',
          ),
          SizedBox(height: 50),
          SizedBox(
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.download,
                size: 20,
                color: Color(0xff002855),
              ),
              label: Text(
                'DESCARGAR PLANTILLA',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xff002855),
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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: Color(0xffFFD60A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
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
            SizedBox(height: 4),
            Text(
              text,
              style: GoogleFonts.inter(
                color: Color(0xffDBEAFE),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

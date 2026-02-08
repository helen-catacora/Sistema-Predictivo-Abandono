import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Card de instrucciones para importación de creación de estudiantes.
class CreacionEstudiantesInstructionsCard extends StatelessWidget {
  const CreacionEstudiantesInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navyMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.navyDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Instrucciones de Importación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStep(
            '1.',
            'Formato de Archivo:',
            'Use archivos CSV, Excel (.xlsx) o JSON. Máximo 10MB por archivo.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '2.',
            'Campos Requeridos:',
            'ID Estudiante, Nombres, Apellidos, Email, Teléfono, Dirección, Semestre.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            '3.',
            'Validación Automática:',
            'El sistema validará duplicados y datos antes de crear los registros.',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Descarga de plantilla en desarrollo'),
                  ),
                );
              },
              icon: const Icon(Icons.download, size: 20),
              label: const Text('DESCARGAR PLANTILLA'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navyDark,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
        Text(
          number,
          style: const TextStyle(
            color: AppColors.accentYellow,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

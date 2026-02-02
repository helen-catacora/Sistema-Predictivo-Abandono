import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'image_placeholder.dart';

/// Panel izquierdo del login con información del sistema EMI.
class LoginLeftPanel extends StatelessWidget {
  const LoginLeftPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppColors.navyDark,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment:
                compact ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const ImagePlaceholder(size: 56, borderRadius: 8),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMI',
                        style: TextStyle(
                          color: AppColors.accentYellow,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CIENCIAS BÁSICAS',
                        style: TextStyle(
                          color: AppColors.accentYellow,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Sistema Predictivo del Abandono Estudiantil',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Control de asistencia y detección temprana de posibles casos '
                'de abandono mediante análisis de datos académicos.',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),
              LoginFeatureItem(
                icon: const ImagePlaceholder(size: 40, borderRadius: 8),
                title: 'Control de Asistencia',
                description:
                    'Registro y seguimiento detallado de la asistencia estudiantil '
                    'en tiempo real',
              ),
              const SizedBox(height: 24),
              LoginFeatureItem(
                icon: const ImagePlaceholder(size: 40, borderRadius: 8),
                title: 'Detección de Riesgos',
                description:
                    'Identificación temprana de estudiantes con posibilidad de '
                    'abandono académico',
              ),
              const SizedBox(height: 24),
              LoginFeatureItem(
                icon: const ImagePlaceholder(size: 40, borderRadius: 8),
                title: 'Gestión Integral',
                description:
                    'Reportes y análisis para la toma de decisiones académicas '
                    'estratégicas',
              ),
              const SizedBox(height: 40),
              Text(
                'ESCUELA MILITAR DE INGENIERÍA',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Excelencia Académica • Formación Integral • Liderazgo',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ítem de característica del panel izquierdo.
class LoginFeatureItem extends StatelessWidget {
  const LoginFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

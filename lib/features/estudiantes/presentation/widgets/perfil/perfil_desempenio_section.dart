import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/estudiante_perfil_response.dart';
import 'perfil_section_card.dart';

/// Sección Desempeño Académico: asistencia general y por materia.
class PerfilDesempenioSection extends StatelessWidget {
  const PerfilDesempenioSection({super.key, this.desempenio});

  final DesempenioAcademicoPerfil? desempenio;

  @override
  Widget build(BuildContext context) {
    final pct = desempenio?.porcentajeAsistenciaGeneral ?? 0;
    final materias = desempenio?.materias ?? [];
    final isCritico = pct < 75;

    return PerfilSectionCard(
      icon: Icons.bar_chart,
      title: 'Desempeño Académico',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ASISTENCIA GENERAL',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCritico ? Colors.red.shade700 : AppColors.navyMedium,
              ),
            ),
            if (isCritico) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 18, color: Colors.orange.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'Nivel crítico - Requiere intervención inmediata',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              height: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (pct / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    pct < 70 ? Colors.red : pct < 85 ? Colors.orange : Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Asistencia por Materia',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (materias.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Sin datos de materias',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              )
            else
              ...materias.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            m.nombre,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${m.porcentajeAsistencia}%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: m.porcentajeAsistencia < 70
                                  ? Colors.red
                                  : m.porcentajeAsistencia < 85
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (m.porcentajeAsistencia / 100).clamp(0.0, 1.0),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  m.porcentajeAsistencia < 70
                                      ? Colors.red
                                      : m.porcentajeAsistencia < 85
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

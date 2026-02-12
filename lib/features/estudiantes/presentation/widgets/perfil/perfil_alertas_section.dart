import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/estudiante_perfil_response.dart';
import 'perfil_section_card.dart';

/// Sección Alertas Activas del perfil.
class PerfilAlertasSection extends StatelessWidget {
  const PerfilAlertasSection({super.key, this.alertas});

  final AlertasPerfil? alertas;

  @override
  Widget build(BuildContext context) {
    final activas = alertas?.activas ?? [];
    final totalHistorial = (alertas?.historial ?? []).length;

    return PerfilSectionCard(
      icon: Icons.warning_amber_rounded,
      title: 'Alertas Activas',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (activas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No hay alertas activas',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              )
            else
              ...activas.map((a) => _AlertaTile(alerta: a)),
            if (totalHistorial > 0) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'Ver Historial de Alertas ($totalHistorial)',
                      style: const TextStyle(
                        color: AppColors.navyMedium,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertaTile extends StatelessWidget {
  const _AlertaTile({required this.alerta});

  final AlertaItemPerfil alerta;

  @override
  Widget build(BuildContext context) {
    final isCritica = (alerta.nivel ?? alerta.estado ?? '')
        .toUpperCase()
        .contains('CRITIC');
    final isAbandono = (alerta.titulo ?? '')
        .toUpperCase()
        .contains('ABANDONO');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isCritica || isAbandono ? Icons.error : Icons.warning_amber_rounded,
                size: 22,
                color: isCritica || isAbandono ? Colors.red.shade700 : Colors.orange.shade700,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alerta.titulo ?? 'Alerta',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (alerta.descripcion != null && alerta.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        alerta.descripcion!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    if (alerta.fechaCreacion != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            _relativeTime(alerta.fechaCreacion!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCritica || isAbandono
                      ? Colors.red.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (alerta.nivel ?? alerta.estado ?? 'ACTIVA').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isCritica || isAbandono
                        ? Colors.red.shade800
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _relativeTime(String iso) {
    try {
      final d = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(d);
      if (diff.inDays > 0) return 'Generada hace ${diff.inDays} días';
      if (diff.inHours > 0) return 'Generada hace ${diff.inHours} horas';
      return 'Generada recientemente';
    } catch (_) {
      return 'Generada';
    }
  }
}

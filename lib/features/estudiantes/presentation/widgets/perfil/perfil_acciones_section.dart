import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/estudiante_perfil_response.dart';
import 'perfil_section_card.dart';

/// Sección Acciones e Intervenciones del perfil.
class PerfilAccionesSection extends StatelessWidget {
  const PerfilAccionesSection({super.key, this.acciones = const []});

  final List<AccionPerfil> acciones;

  @override
  Widget build(BuildContext context) {
    return PerfilSectionCard(
      icon: Icons.assignment_outlined,
      title: 'Acciones e Intervenciones',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nueva Acción'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.grayDark,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
            if (acciones.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No hay acciones registradas',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              )
            else
              ...acciones.take(10).map((a) => _AccionTile(accion: a)),
          ],
        ),
      ),
    );
  }
}

class _AccionTile extends StatelessWidget {
  const _AccionTile({required this.accion});

  final AccionPerfil accion;

  @override
  Widget build(BuildContext context) {
    final desc = accion.descripcion ?? '';
    final titulo = desc.length > 60 ? '${desc.substring(0, 60)}...' : desc;
    final fecha = accion.fecha ?? '-';

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
          Text(
            titulo.isEmpty ? 'Acción #${accion.id}' : titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                _formatFecha(fecha),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatFecha(String iso) {
    if (iso == '-') return iso;
    try {
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;
      final now = DateTime.now();
      final diff = now.difference(d);
      if (diff.inDays == 0) return 'Hoy, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      if (diff.inDays == 1) return 'Ayer';
      if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
      if (diff.inDays < 30) return 'Hace ${(diff.inDays / 7).floor()} semana(s)';
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

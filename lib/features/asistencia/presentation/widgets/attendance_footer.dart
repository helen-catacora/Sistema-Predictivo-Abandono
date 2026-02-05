import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/asistencias_provider.dart';

/// Pie de página del registro de asistencia.
class AttendanceFooter extends StatelessWidget {
  const AttendanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AsistenciasProvider>(
      builder: (context, provider, _) {
        final hasData = provider.hasData;
        final hasModified = provider.getModifiedForSave().isNotEmpty;
        final canSave =
            hasData && hasModified && !provider.isSaving;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (provider.isSaving)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFF22C55E),
                    ),
                  )
                else
                  Icon(
                    Icons.cloud_done,
                    size: 20,
                    color: hasModified
                        ? Colors.orange
                        : const Color(0xFF22C55E),
                  ),
                const SizedBox(width: 8),
                Text(
                  provider.isSaving
                      ? 'Guardando...'
                      : hasModified
                          ? 'Hay cambios sin guardar'
                          : 'Sin cambios pendientes',
                  style: TextStyle(
                    color: AppColors.grayMedium,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navyMedium,
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: canSave
                      ? () => _onFinalizarRegistro(context, provider)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                  ),
                  child: const Text('Finalizar Registro'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _onFinalizarRegistro(
    BuildContext context,
    AsistenciasProvider provider,
  ) async {
    final ok = await provider.saveAsistenciasDia();
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de asistencia guardado correctamente'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Error al guardar asistencia',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Panel de acciones (GUARDAR, LIMPIAR, CANCELAR).
class UserFormActions extends StatelessWidget {
  const UserFormActions({
    super.key,
    required this.onGuardar,
    required this.onLimpiar,
    required this.onCancelar,
  });

  final VoidCallback onGuardar;
  final VoidCallback onLimpiar;
  final VoidCallback onCancelar;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ACCIONES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.grayDark,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onGuardar,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('GUARDAR USUARIO'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.navyMedium,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onLimpiar,
              icon: const Icon(Icons.cleaning_services_outlined, size: 20),
              label: const Text('LIMPIAR FORMULARIO'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navyMedium,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCancelar,
              icon: const Icon(Icons.close, size: 20),
              label: const Text('CANCELAR'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.grayDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

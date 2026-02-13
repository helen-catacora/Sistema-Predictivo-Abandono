import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Sección "Configuración de Cuenta" con card de cambiar contraseña.
class MiPerfilAccountConfig extends StatelessWidget {
  const MiPerfilAccountConfig({
    super.key,
    this.ultimaActualizacionPassword = 'hace 3 meses',
    this.onActualizarPassword,
  });

  final String ultimaActualizacionPassword;
  final VoidCallback? onActualizarPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Configuración de Cuenta',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.greyF1F5F9,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.greyE2E8F0),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 32, color: AppColors.blue1D4ED8),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cambiar Contraseña',
                      style: TextStyle(
                        color: AppColors.black0F172A,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                  ],
                ),
              ),
              FilledButton(
                onPressed: onActualizarPassword ?? () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navyMedium,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

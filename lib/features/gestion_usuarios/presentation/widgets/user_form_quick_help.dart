import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Panel Ayuda Rápida.
class UserFormQuickHelp extends StatelessWidget {
  const UserFormQuickHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.blueLight.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.blueLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.navyMedium),
                const SizedBox(width: 8),
                Text(
                  'Ayuda Rápida',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Consejos para el registro',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grayMedium,
              ),
            ),
            const SizedBox(height: 12),
            _TipItem(
              'Verifique que el correo institucional sea válido antes de registrar',
            ),
            _TipItem(
              'La contraseña debe cumplir con los requisitos de seguridad',
            ),
            _TipItem(
              'Asigne el rol apropiado según las funciones del usuario',
            ),
            _TipItem(
              'El usuario recibirá un correo con sus credenciales',
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navyMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grayDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

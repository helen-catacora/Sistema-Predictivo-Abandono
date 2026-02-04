import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Pie de página global del login.
class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.navyDark,
      child: Text(
        '© ${DateTime.now().year} Escuela Militar de Ingeniería - Todos los derechos reservados',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.grayMedium,
          fontSize: 12,
        ),
      ),
    );
  }
}

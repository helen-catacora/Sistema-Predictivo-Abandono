import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Encabezado de sección con barra amarilla vertical.
class ImportSectionHeader extends StatelessWidget {
  const ImportSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.accentYellow,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: AppColors.navyMedium,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

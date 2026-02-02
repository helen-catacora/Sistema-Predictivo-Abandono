import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Pie de página del panel de control.
class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2024 ESCUELA MILITAR DE INGENIERÍA - CIENCIAS BÁSICAS',
            style: TextStyle(
              color: AppColors.grayDark,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Text(
                'PRIVACIDAD',
                style: TextStyle(
                  color: AppColors.grayDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'REGLAMENTOS',
                style: TextStyle(
                  color: AppColors.grayDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'SOPORTE',
                style: TextStyle(
                  color: AppColors.grayDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

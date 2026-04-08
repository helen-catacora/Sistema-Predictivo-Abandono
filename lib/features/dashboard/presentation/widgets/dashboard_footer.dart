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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copyrightText = Flexible(
            child: Text(
              '© ${DateTime.now().year} ESCUELA MILITAR DE INGENIERÍA - CIENCIAS BÁSICAS',
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
          final linksRow = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                'MANUAL DE USUARIO',
                style: TextStyle(
                  color: AppColors.grayDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                copyrightText,
                const SizedBox(height: 8),
                linksRow,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              copyrightText,
              linksRow,
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección de filtros para generación de reportes.
class ReportsFilterSection extends StatelessWidget {
  const ReportsFilterSection({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.keyboard_arrow_down, color: AppColors.grayDark),
                const SizedBox(width: 4),
                Text(
                  'Filtros de Generación',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FilterField(
                    label: 'PERÍODO',
                    value: 'gestion2024',
                    displayText: 'Gestión 2024',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _FilterField(
                    label: 'NIVEL DE RIESGO',
                    value: 'todos',
                    displayText: 'Todos los niveles',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _FilterField(
                    label: 'CARRERA/ÁREA',
                    value: 'todas',
                    displayText: 'Todas las carreras',
                  ),
                ),
                const SizedBox(width: 20),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('APLICAR FILTROS'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navyMedium,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.value,
    required this.displayText,
  });

  final String label;
  final String value;
  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grayDark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            isDense: true,
          ),
          items: [
            DropdownMenuItem(value: value, child: Text(displayText)),
          ],
          onChanged: (_) {},
        ),
      ],
    );
  }
}

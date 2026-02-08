import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Datos de ejemplo por paralelo.
class _ParaleloCardData {
  const _ParaleloCardData(
    this.nombre,
    this.semestre,
    this.totalEstudiantes,
    this.riesgoAlto,
    this.critico,
  );
  final String nombre;
  final String semestre;
  final int totalEstudiantes;
  final int riesgoAlto;
  final int critico;
}

/// Sección Resumen por Paralelo con 4 tarjetas.
class ResumenParaleloSection extends StatelessWidget {
  const ResumenParaleloSection({super.key});

  static const _paralelos = [
    _ParaleloCardData('Paralelo A', '1ER SEMESTRE', 42, 8, 3),
    _ParaleloCardData('Paralelo B', '1ER SEMESTRE', 38, 12, 5),
    _ParaleloCardData('Paralelo C', '2DO SEMESTRE', 45, 6, 2),
    _ParaleloCardData('Paralelo D', '2DO SEMESTRE', 40, 10, 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.navyMedium,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Resumen por Paralelo',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _paralelos
                    .map((p) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _ParaleloCard(data: p),
                          ),
                        ))
                    .toList(),
              );
            }
            return Column(
              children: _paralelos
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ParaleloCard(data: p),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ParaleloCard extends StatelessWidget {
  const _ParaleloCard({required this.data});

  final _ParaleloCardData data;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.nombre,
                  style: const TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.groups_outlined,
                  size: 28,
                  color: AppColors.blueLight,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data.semestre,
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Estudiantes: ${data.totalEstudiantes}',
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Riesgo Alto: ',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${data.riesgoAlto}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Crítico: ',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${data.critico}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

/// Sección Resumen por Paralelo (datos de distribucion_por_paralelo).
class ResumenParaleloSection extends StatelessWidget {
  const ResumenParaleloSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final paralelos = dashboard.distribucionPorParalelo;
        final isLoading = dashboard.isLoading;
        final hasError = dashboard.hasError;

        if (hasError && paralelos.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              const SizedBox(height: 16),
              Text(
                dashboard.errorMessage ?? 'Error al cargar',
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            ],
          );
        }

        if (isLoading && paralelos.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              const SizedBox(height: 24),
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            const SizedBox(height: 16),
            paralelos.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No hay datos de distribución por paralelo.',
                      style: TextStyle(
                        color: AppColors.grayMedium,
                        fontSize: 13,
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: paralelos
                              .map((p) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _ParaleloCard(item: p),
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                      return Column(
                        children: paralelos
                            .map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ParaleloCard(item: p),
                                ))
                            .toList(),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
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
    );
  }
}

class _ParaleloCard extends StatelessWidget {
  const _ParaleloCard({required this.item});

  final DistribucionPorParaleloItem item;

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
                  item.paralelo,
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
              item.area,
              style: TextStyle(
                color: AppColors.grayMedium,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Estudiantes: ${item.total}',
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
                  '${item.altoRiesgo}',
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
                  '${item.critico}',
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

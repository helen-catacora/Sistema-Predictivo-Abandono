import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../estudiantes/presentation/providers/estudiantes_provider.dart';
import '../../../estudiantes/presentation/widgets/student_table.dart';

/// Sección Seguimiento de Alumnos con tabla (primeros 3 estudiantes).
/// "Ver todos los estudiantes" navega a /home/estudiantes.
class SeguimientoAlumnosSection extends StatefulWidget {
  const SeguimientoAlumnosSection({super.key});

  @override
  State<SeguimientoAlumnosSection> createState() =>
      _SeguimientoAlumnosSectionState();
}

class _SeguimientoAlumnosSectionState extends State<SeguimientoAlumnosSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstudiantesProvider>().loadEstudiantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xff002855), width: 4)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Seguimiento de Alumnos',
                      style: TextStyle(
                        color: AppColors.navyMedium,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // OutlinedButton.icon(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.filter_list, size: 18),
                    //   label: const Text('Filtrar'),
                    //   style: OutlinedButton.styleFrom(
                    //     foregroundColor: AppColors.grayDark,
                    //   ),
                    // ),
                    // const SizedBox(width: 12),
                    // FilledButton.icon(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.download, size: 18),
                    //   label: const Text('Exportar'),
                    //   style: FilledButton.styleFrom(
                    //     backgroundColor: AppColors.navyMedium,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<EstudiantesProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.estudiantes.isEmpty) {
                  return _buildLoadingCard();
                }
                if (provider.hasError && provider.estudiantes.isEmpty) {
                  return _buildErrorCard(
                    provider.errorMessage ?? 'Error al cargar',
                    provider.loadEstudiantes,
                  );
                }
                final primerosTres = provider.estudiantes.take(3).toList();
                return StudentDataTable(estudiantes: primerosTres);
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.homeEstudiantes),
                child: const Text(
                  'Ver todos los estudiantes',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Cargando estudiantes...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, VoidCallback onRetry) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.red.shade700),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

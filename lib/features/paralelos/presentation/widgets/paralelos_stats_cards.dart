import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../../../panel_principal/presentation/providers/dashboard_provider.dart';

/// Tarjetas de resumen: Total Paralelos, Con Encargado, Sin Encargado, Total Estudiantes.
class ParalelosStatsCards extends StatelessWidget {
  const ParalelosStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // const spacing = 20.0;
        // const minCardWidth = 220.0;
        // final crossAxisCount = (constraints.maxWidth / (minCardWidth + spacing))
        //     .floor()
        //     .clamp(1, 4);
        return Consumer2<ParalelosProvider, DashboardProvider>(
          builder: (context, paralelosProvider, dashboardProvider, _) {
            final list = paralelosProvider.paralelos;
            final total = list.length;
            final conEncargado = list
                .where((p) => p.nombreEncargado.trim().isNotEmpty)
                .length;
            final sinEncargado = total - conEncargado;
            final porcentaje = total > 0
                ? ((conEncargado / total) * 100).toStringAsFixed(1)
                : '0';
            final totalEstudiantes =
                dashboardProvider.resumenGeneral?.totalEstudiantes ?? 0;
            final year = DateTime.now().year;
            return Row(
              spacing: 12,
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'TOTAL PARALELOS',
                    value: total.toString(),
                    subtitle: 'Activos en gestión $year',
                    icon: Icons.layers_outlined,
                    color: const Color(0xFF0891B2),
                    imagePath: 'assets/total-paralelos.png',
                  ),
                ),
                Expanded(
                  child: _StatCard(
                    title: 'CON ENCARGADO',
                    value: conEncargado.toString(),
                    subtitle: '$porcentaje% asignados',
                    icon: Icons.person_outline,
                    color: AppColors.green16A34A,
                    imagePath: 'assets/encargados.png',
                  ),
                ),
                Expanded(
                  child: _StatCard(
                    title: 'SIN ENCARGADO',
                    value: sinEncargado.toString(),
                    subtitle: 'Requieren asignación',
                    icon: Icons.person_off_outlined,
                    color: const Color(0xFFEA580C),
                    imagePath: 'assets/sin-encargado.png',
                  ),
                ),
                Expanded(
                  child: _StatCard(
                    title: 'TOTAL ESTUDIANTES',
                    value: totalEstudiantes.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    ),
                    subtitle: 'Distribuidos en $total paralelos',
                    icon: Icons.school_outlined,
                    color: AppColors.blue1D4ED8,
                    imagePath: 'assets/total-estudiantes.png',
                  ),
                ),
              ],
            );
            // return GridView.count(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisCount: crossAxisCount,
            //   mainAxisSpacing: spacing,
            //   crossAxisSpacing: spacing,
            //   childAspectRatio: 1.5,
            //   children: [
            //     _StatCard(
            //       title: 'TOTAL PARALELOS',
            //       value: total.toString(),
            //       subtitle: 'Activos en gestión $year',
            //       icon: Icons.layers_outlined,
            //       color: const Color(0xFF0891B2),
            //     ),
            //     _StatCard(
            //       title: 'CON ENCARGADO',
            //       value: conEncargado.toString(),
            //       subtitle: '$porcentaje% asignados',
            //       icon: Icons.person_outline,
            //       color: AppColors.green16A34A,
            //     ),
            //     _StatCard(
            //       title: 'SIN ENCARGADO',
            //       value: sinEncargado.toString(),
            //       subtitle: 'Requieren asignación',
            //       icon: Icons.person_off_outlined,
            //       color: const Color(0xFFEA580C),
            //     ),
            //     _StatCard(
            //       title: 'TOTAL ESTUDIANTES',
            //       value: totalEstudiantes.toString().replaceAllMapped(
            //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            //         (m) => '${m[1]},',
            //       ),
            //       subtitle: 'Distribuidos en $total paralelos',
            //       icon: Icons.school_outlined,
            //       color: AppColors.blue1D4ED8,
            //     ),
            //   ],
            // );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.imagePath,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(imagePath, height: 90, width: 90),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.grey64748B,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 16 / 12,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Color(0xff1E293B),
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: Color(0xff94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

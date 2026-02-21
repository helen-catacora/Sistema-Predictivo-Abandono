import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';

/// Sección Resumen por Paralelo (datos de distribucion_por_paralelo).
class ResumenParaleloSection extends StatefulWidget {
  const ResumenParaleloSection({super.key});

  @override
  State<ResumenParaleloSection> createState() => _ResumenParaleloSectionState();
}

class _ResumenParaleloSectionState extends State<ResumenParaleloSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Consumer<DashboardProvider>(
          builder: (context, dashboard, _) {
            // final paralelos = [dashboard.distribucionPorParalelo[0]];
            final isLoading = dashboard.isLoading;
            final hasError = dashboard.hasError;

            if (hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildTitle(context),
                  const SizedBox(height: 16),
                  Text(
                    dashboard.errorMessage ?? 'Error al cargar',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ],
              );
            }

            if (isLoading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildTitle(context),
                  const SizedBox(height: 24),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            final paralelos = dashboard.distribucionPorParalelo;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildTitle(context),
                // const SizedBox(height: 16),
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
                            return Scrollbar(
                              trackVisibility: true,
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // children: paralelos
                                  //     .map(
                                  //       (p) => Padding(
                                  //         padding: const EdgeInsets.only(right: 12),
                                  //         child: _ParaleloCard(item: p),
                                  //       ),
                                  //     )
                                  //     .toList(),
                                  children: List.generate(paralelos.length, (
                                    index,
                                  ) {
                                    final paralelo = paralelos[index];
                                    return Container(
                                      padding: const EdgeInsets.only(right: 12),
                                      margin: EdgeInsets.only(
                                        left: index == 0 ? 20 : 0,
                                        right: (index == paralelos.length - 1)
                                            ? 20
                                            : 0,
                                        bottom: 24,
                                      ),
                                      child: _ParaleloCard(item: paralelo),
                                    );
                                  }),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: paralelos
                                .map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ParaleloCard(item: p),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
              ],
            );
          },
        ),
      ),
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
    return Container(
      width: 360,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffDBEAFE), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF)],
          stops: [0.0, 1.0],
        ),
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
                  'PARALELO ${item.paralelo.toUpperCase()}',
                  style: GoogleFonts.inter(
                    color: AppColors.gray002855,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 32 / 24,
                    letterSpacing: 0,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xffDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Image.asset('assets/poblacion.png')),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.area,
              style: GoogleFonts.inter(
                color: AppColors.grey94A3B8,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 16),
            ParaleloInfoData(
              title: 'Total Estudiantes',
              value: '${item.total}',
              valueColor: AppColors.darkBlue1E293B,
            ),
            ParaleloInfoData(
              title: 'Riesgo Alto',
              value: '${item.altoRiesgo}',
              valueColor: Color(0xffCA8A04),
            ),
            ParaleloInfoData(
              title: 'Critico',
              value: '${item.critico}',
              valueColor: Color(0xffDC2626),
            ),
          ],
        ),
      ),
    );
  }
}

class ParaleloInfoData extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  const ParaleloInfoData({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            color: AppColors.grey64748B,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
            letterSpacing: 0,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 28 / 18,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

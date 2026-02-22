import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../widgets/alertas_criticas_section.dart';
import '../widgets/estado_academico_section.dart';
import '../widgets/resumen_paralelo_section.dart';
import '../widgets/tendencia_historica_section.dart';

/// Pantalla Panel Principal del Sistema Predictivo de Abandono.
/// Diseño: Estado Académico, Distribución de Riesgo + Alertas Críticas,
/// Resumen por Paralelo, Seguimiento de Alumnos.
/// Los datos provienen de GET /api/v1/predicciones/dashboard.
class PanelPrincipalPage extends StatefulWidget {
  const PanelPrincipalPage({super.key});

  @override
  State<PanelPrincipalPage> createState() => _PanelPrincipalPageState();
}

class _PanelPrincipalPageState extends State<PanelPrincipalPage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DashboardProvider>().loadDashboard();
    //   context.read<AlertasProvider>().loadAlertas();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ScreenDescriptionCard(
            description:
                'Vista general del sistema predictivo de abandono estudiantil: estado académico, tendencia histórica, alertas críticas, resumen por paralelo y seguimiento de alumnos.',
            icon: Icons.dashboard_rounded,
          ),
          const SizedBox(height: 24),
          const EstadoAcademicoSection(),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (_, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Distribución de riesgo por nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Text(
                          'Alertas Críticas',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: const TendenciaHistoricaSection(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: const AlertasCriticasSection()),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Text(
                    'Distribución de riesgo por nivel',
                    style: GoogleFonts.inter(
                      color: AppColors.gray002855,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 36 / 30,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 24),
                  TendenciaHistoricaSection(),
                  SizedBox(height: 20),
                  Text(
                    'Alertas Críticas',
                    style: GoogleFonts.inter(
                      color: AppColors.gray002855,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 36 / 30,
                      letterSpacing: 0,
                    ),
                  ),
                  AlertasCriticasSection(),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Resumen por Paralelo',
            style: GoogleFonts.inter(
              color: AppColors.gray002855,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 36 / 30,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 24),
          ResumenParaleloSection(),
          // SizedBox(height: 24),
          // Text(
          //   'Seguimiento de Alumnos',
          //   style: GoogleFonts.inter(
          //     color: AppColors.gray002855,
          //     fontSize: 30,
          //     fontWeight: FontWeight.w700,
          //     height: 36 / 30,
          //     letterSpacing: 0,
          //   ),
          // ),
          // const SizedBox(height: 24),
          // const SeguimientoAlumnosSection(),
        ],
      ),
    );
  }
}

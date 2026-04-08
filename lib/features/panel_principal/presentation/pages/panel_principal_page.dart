import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/shared/widgets/refresh_button.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../providers/alertas_provider.dart';
import '../providers/dashboard_provider.dart';
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
  final GlobalKey _keyEstadoAcademico = GlobalKey();
  final GlobalKey _keyTendencia = GlobalKey();
  final GlobalKey _keyAlertas = GlobalKey();
  final GlobalKey _keyResumenParalelo = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  String? _lastSeccion;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final seccion = GoRouterState.of(context).uri.queryParameters['seccion'];
    if (seccion != null && seccion != _lastSeccion) {
      _lastSeccion = seccion;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scrollToSectionByName(seccion);
      });
    } else if (seccion == null) {
      _lastSeccion = null;
    }
  }

  void _scrollToSectionByName(String seccion) {
    switch (seccion) {
      case 'estado_academico':
        _scrollToSection(_keyEstadoAcademico);
      case 'distribucion_riesgo':
        _scrollToSection(_keyTendencia);
      case 'alertas_criticas':
        _scrollToSection(_keyAlertas);
      case 'resumen_paralelo':
        _scrollToSection(_keyResumenParalelo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Panel Predictivo',
                style: GoogleFonts.inter(
                  color: AppColors.gray002855,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 36 / 30,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(),
              RefreshButton(
                onTap: () {
                  context.read<DashboardProvider>().loadDashboard();
                  context.read<AlertasProvider>().loadAlertas();
                },
              ),
            ],
          ),
        const SizedBox(height: 24),
          const ScreenDescriptionCard(
            description:
                'Vista general del sistema predictivo de abandono estudiantil: estado académico, tendencia histórica, alertas críticas y resumen por paralelo.',
            icon: Icons.dashboard_rounded,
          ),
          const SizedBox(height: 24),
          _sectionAnchor(key: _keyEstadoAcademico, child: const EstadoAcademicoSection()),
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
                          'Distribución de Riesgo por Nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 25,
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
                            fontSize: 25,
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
                        child: _sectionAnchor(
                          key: _keyTendencia,
                          child: const TendenciaHistoricaSection(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _sectionAnchor(
                          key: _keyAlertas,
                          child: const AlertasCriticasSection(),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  _sectionAnchor(
                    key: _keyTendencia,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Distribución de Riesgo por Nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const TendenciaHistoricaSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionAnchor(
                    key: _keyAlertas,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Alertas Críticas',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                        const AlertasCriticasSection(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _sectionAnchor(
            key: _keyResumenParalelo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumen por Paralelo',
                  style: GoogleFonts.inter(
                    color: AppColors.gray002855,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 36 / 30,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                ResumenParaleloSection(),
              ],
            ),
          ),
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

  Widget _sectionAnchor({required GlobalKey key, required Widget child}) {
    return KeyedSubtree(key: key, child: child);
  }
}

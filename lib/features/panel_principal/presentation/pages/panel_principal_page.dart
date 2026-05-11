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
import '../widgets/distribucion_burbujas_section.dart';
import '../widgets/estado_academico_oficial_section.dart';
import '../widgets/estado_academico_section.dart';
import '../widgets/resumen_paralelo_section.dart';
import '../widgets/matriz_calor_section.dart';
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

  bool _vistaOficial = false;

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
              _buildVistaToggle(),
              const SizedBox(width: 12),
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
          _sectionAnchor(
            key: _keyEstadoAcademico,
            child: _vistaOficial
                ? const EstadoAcademicoOficialSection()
                : const EstadoAcademicoSection(),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (_, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          _vistaOficial
                              ? 'Distribución de Riesgo por Burbuja'
                              : 'Distribución de Riesgo por Nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
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
                          child: _vistaOficial
                              ? const DistribucionBurbujasSection()
                              : const TendenciaHistoricaSection(),
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
                          _vistaOficial
                              ? 'Distribución de Riesgo por Burbuja'
                              : 'Distribución de Riesgo por Nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 36 / 30,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_vistaOficial)
                          const SizedBox(
                            height: 320,
                            child: DistribucionBurbujasSection(),
                          )
                        else
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
          // ── MATRIZ DE CALOR ── comentar este bloque para ocultar el widget ──────────
          const SizedBox(height: 24),
          Text(
            'Matriz de Calor de Riesgos',
            style: GoogleFonts.inter(
              color: AppColors.gray002855,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              height: 36 / 30,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          const MatrizCalorSection(),
          // ─────────────────────────────────────────────────────────────────────────────

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

  Widget _buildVistaToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyF1F5F9,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyE2E8F0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vista Secundaria',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _vistaOficial
                  ? AppColors.gray002855
                  : AppColors.grey64748B,
            ),
          ),
          const SizedBox(width: 4),
          Switch(
            value: _vistaOficial,
            onChanged: (v) => setState(() => _vistaOficial = v),
            activeThumbColor: AppColors.gray002855,
            activeTrackColor: AppColors.blueDBEAFE,
            inactiveThumbColor: AppColors.grayMedium,
            inactiveTrackColor: AppColors.greyE2E8F0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _sectionAnchor({required GlobalKey key, required Widget child}) {
    return KeyedSubtree(key: key, child: child);
  }
}

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

  @override
  void initState() {
    super.initState();
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
          const SizedBox(height: 16),
          _buildSectionSubmenu(),
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
                          'Distribución de riesgo por nivel',
                          style: GoogleFonts.inter(
                            color: AppColors.gray002855,
                            fontSize: 30,
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
                            fontSize: 30,
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
          const SizedBox(height: 24),
          _sectionAnchor(
            key: _keyResumenParalelo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 24),
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

  /// Submenú horizontal scrolleable para saltar a cada sección.
  Widget _buildSectionSubmenu() {
    const items = [
      ('Estado Académico', Icons.school_outlined),
      ('Distribución de riesgo', Icons.show_chart),
      ('Alertas Críticas', Icons.warning_amber_rounded),
      ('Resumen por Paralelo', Icons.groups_outlined),
    ];
    final keys = [_keyEstadoAcademico, _keyTendencia, _keyAlertas, _keyResumenParalelo];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final (label, icon) = items[i];
          return Padding(
            padding: EdgeInsets.only(right: i < items.length - 1 ? 12 : 0),
            child: Material(
              color: AppColors.gray002855.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => _scrollToSection(keys[i]),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 18, color: AppColors.gray002855),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray002855,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionAnchor({required GlobalKey key, required Widget child}) {
    return KeyedSubtree(key: key, child: child);
  }
}

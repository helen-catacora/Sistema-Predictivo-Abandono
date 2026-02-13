import 'package:flutter/material.dart';
import '../widgets/alertas_criticas_section.dart';
import '../widgets/estado_academico_section.dart';
import '../widgets/resumen_paralelo_section.dart';
import '../widgets/seguimiento_alumnos_section.dart';
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
          const EstadoAcademicoSection(),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: const TendenciaHistoricaSection()),
                    const SizedBox(width: 20),
                    Expanded(child: const AlertasCriticasSection()),
                  ],
                );
              }
              return const Column(
                children: [
                  TendenciaHistoricaSection(),
                  SizedBox(height: 20),
                  AlertasCriticasSection(),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const ResumenParaleloSection(),
          const SizedBox(height: 24),
          const SeguimientoAlumnosSection(),
        ],
      ),
    );
  }
}

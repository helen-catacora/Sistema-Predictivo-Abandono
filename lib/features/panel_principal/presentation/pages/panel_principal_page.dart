import 'package:flutter/material.dart';

import '../widgets/alertas_criticas_section.dart';
import '../widgets/estado_academico_section.dart';
import '../widgets/seguimiento_alumnos_section.dart';
import '../widgets/tendencia_historica_section.dart';

/// Pantalla Panel Principal del Sistema Predictivo de Abandono.
class PanelPrincipalPage extends StatelessWidget {
  const PanelPrincipalPage({super.key});

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
                    Expanded(
                      flex: 2,
                      child: const TendenciaHistoricaSection(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: const AlertasCriticasSection(),
                    ),
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
          const SeguimientoAlumnosSection(),
        ],
      ),
    );
  }
}

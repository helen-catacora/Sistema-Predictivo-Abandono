import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/widgets/reports_header.dart';
import 'package:sistemapredictivoabandono/features/reportes/presentation/widgets/reports_recent_table.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

class HistorialReportesPage extends StatelessWidget {
  const HistorialReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ReportsHeader(title: 'Historial de Reportes'),
          const SizedBox(height: 16),
          const ScreenDescriptionCard(
            description:
                'Centro de reportes para análisis integral del abandono estudiantil. Consulte el historial reciente.',
            icon: Icons.assessment_outlined,
          ),
          const SizedBox(height: 24),
          const ReportsRecentTable(),
        ],
      ),
    );
  }
}

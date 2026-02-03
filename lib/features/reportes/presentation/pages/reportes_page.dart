import 'package:flutter/material.dart';

import '../widgets/reports_available_section.dart';
import '../widgets/reports_charts_section.dart';
import '../widgets/reports_filter_section.dart';
import '../widgets/reports_header.dart';
import '../widgets/reports_metrics_cards.dart';
import '../widgets/reports_recent_table.dart';

/// Pantalla Centro de Reportes.
class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ReportsHeader(),
          const SizedBox(height: 24),
          const ReportsFilterSection(),
          const SizedBox(height: 24),
          const ReportsMetricsCards(),
          const SizedBox(height: 24),
          const ReportsChartsSection(),
          const SizedBox(height: 24),
          const ReportsAvailableSection(),
          const SizedBox(height: 24),
          const ReportsRecentTable(),
        ],
      ),
    );
  }
}

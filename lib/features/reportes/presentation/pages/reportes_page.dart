import 'package:flutter/material.dart';
import '../widgets/reports_available_section.dart';
import '../widgets/reports_header.dart';
import '../widgets/reports_recent_table.dart';

/// Pantalla Centro de Reportes.
class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ReportesTiposProvider>().loadTipos();
      // context.read<ReportesHistorialProvider>().loadHistorial(
      //   page: 1,
      //   pageSize: 20,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ReportsHeader(),
          const SizedBox(height: 24),
          //  const ReportsFilterSection(),
          //  const SizedBox(height: 24),
          //  const ReportsMetricsCards(),
          //  const SizedBox(height: 24),
          //  const ReportsChartsSection(),
          //  const SizedBox(height: 24),
          const ReportsAvailableSection(),
          const SizedBox(height: 24),
          const ReportsRecentTable(),
        ],
      ),
    );
  }
}

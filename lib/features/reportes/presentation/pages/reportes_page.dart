import 'package:flutter/material.dart';

/// Pantalla Reportes.
class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Reportes',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

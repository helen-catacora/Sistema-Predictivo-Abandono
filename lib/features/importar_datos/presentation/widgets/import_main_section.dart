import 'package:flutter/material.dart';

import 'import_instructions_panel.dart';
import 'import_summary_cards.dart';

/// Sección principal: instrucciones y tarjetas de resumen.
class ImportMainSection extends StatelessWidget {
  const ImportMainSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth > 900;
        if (useRow) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: ImportInstructionsPanel()),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: ImportSummaryCards()),
              ],
            ),
          );
        }
        return Column(
          children: [
            SizedBox(height: 380, child: ImportInstructionsPanel()),
            const SizedBox(height: 24),
            ImportSummaryCards(),
          ],
        );
      },
    );
  }
}

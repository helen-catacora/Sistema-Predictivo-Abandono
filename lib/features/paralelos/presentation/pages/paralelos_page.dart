import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../widgets/paralelos_header.dart';
import '../widgets/paralelos_list_section.dart';
import '../widgets/paralelos_stats_cards.dart';

/// Pantalla de Gestión de Paralelos: administración de cursos y asignación de encargados.
class ParalelosPage extends StatefulWidget {
  const ParalelosPage({super.key});

  @override
  State<ParalelosPage> createState() => _ParalelosPageState();
}

class _ParalelosPageState extends State<ParalelosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParalelosProvider>().loadParalelos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const ParalelosHeader(),
                const SizedBox(height: 20),
                const ScreenDescriptionCard(
                  description:
                      'Administración de cursos (paralelos) y asignación de encargados. Gestione la estructura académica de la carrera.',
                  icon: Icons.groups_outlined,
                ),
                const SizedBox(height: 24),
                const ParalelosStatsCards(),
                const SizedBox(height: 24),
                const ParalelosListSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

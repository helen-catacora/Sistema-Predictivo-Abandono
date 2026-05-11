import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/screen_description_card.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../providers/gestiones_provider.dart';
import '../widgets/gestiones_header.dart';
import '../widgets/gestiones_list_section.dart';

class GestionesPage extends StatefulWidget {
  const GestionesPage({super.key});

  @override
  State<GestionesPage> createState() => _GestionesPageState();
}

class _GestionesPageState extends State<GestionesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GestionesProvider>().loadGestiones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = Responsive.contentPadding(constraints.maxWidth);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GestionesHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding.left),
                child: const ScreenDescriptionCard(
                  description:
                      'Configura los períodos en que se permite importar o registrar estudiantes. Crea gestiones académicas, activa la vigente y define la ventana de fechas habilitada.',
                  icon: Icons.date_range_outlined,
                ),
              ),
              const SizedBox(height: 24),
              const GestionesListSection(),
            ],
          ),
        );
      },
    );
  }
}

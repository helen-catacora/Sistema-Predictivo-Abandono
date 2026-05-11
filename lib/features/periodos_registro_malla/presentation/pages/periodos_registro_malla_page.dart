import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/refresh_button.dart';
import '../../../../shared/widgets/screen_description_card.dart';
import '../providers/periodos_registro_malla_provider.dart';
import '../widgets/periodos_registro_malla_list_section.dart';

class PeriodosRegistroMallaPage extends StatefulWidget {
  const PeriodosRegistroMallaPage({super.key});

  @override
  State<PeriodosRegistroMallaPage> createState() => _PeriodosRegistroMallaPageState();
}

class _PeriodosRegistroMallaPageState extends State<PeriodosRegistroMallaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PeriodosRegistroMallaProvider>().loadPeriodos();
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding.left),
                child: Row(
                  children: [
                    Text(
                      'Períodos de Registro de Malla',
                      style: GoogleFonts.inter(
                        color: AppColors.gray002855,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 36 / 30,
                      ),
                    ),
                    const Spacer(),
                    RefreshButton(
                      onTap: () => context.read<PeriodosRegistroMallaProvider>().loadPeriodos(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding.left),
                child: const ScreenDescriptionCard(
                  description:
                      'Administra los períodos en que se permite importar o actualizar la malla curricular. '
                      'Solo puede haber un período activo a la vez. '
                      'Si no hay un período activo, la importación de malla estará bloqueada.',
                  icon: Icons.calendar_month_outlined,
                ),
              ),
              const SizedBox(height: 24),
              const PeriodosRegistroMallaListSection(),
            ],
          ),
        );
      },
    );
  }
}

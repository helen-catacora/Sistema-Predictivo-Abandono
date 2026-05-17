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
        final fontSize = Responsive.pageTitleFontSize(constraints.maxWidth);
        final isMobile = Responsive.isMobile(constraints.maxWidth);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header con padding solo horizontal (como en el 'antes') y responsivo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding.left), 
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(fontSize),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RefreshButton(
                              onTap: () => context.read<PeriodosRegistroMallaProvider>().loadPeriodos(),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildTitle(fontSize)),
                          RefreshButton(
                            onTap: () => context.read<PeriodosRegistroMallaProvider>().loadPeriodos(),
                          ),
                        ],
                      ),
              ),
              
              const SizedBox(height: 20),
              
              // 2. Tarjeta con su padding horizontal original
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
              
              // 3. Tabla SIN padding extra, respetando sus propios márgenes internos
              const PeriodosRegistroMallaListSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(double fontSize) {
    return Text(
      'Períodos de Registro de Malla',
      style: GoogleFonts.inter(
        color: AppColors.gray002855,
        fontSize: fontSize, // Aquí está la magia responsiva
        fontWeight: FontWeight.w700,
        height: 36 / 30,
      ),
    );
  }
}
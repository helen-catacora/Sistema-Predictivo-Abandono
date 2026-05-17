import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/refresh_button.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';

/// Encabezado de la pantalla Gestión de Paralelos.
class ParalelosHeader extends StatelessWidget {
  const ParalelosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = Responsive.pageTitleFontSize(constraints.maxWidth);
        final isMobile = Responsive.isMobile(constraints.maxWidth);
        final padding = Responsive.contentPadding(constraints.maxWidth);

        return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, padding.right, 0),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(fontSize),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RefreshButton(
                        onTap: () => context.read<ParalelosProvider>().loadParalelos(),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _title(fontSize)),
                    RefreshButton(
                      onTap: () => context.read<ParalelosProvider>().loadParalelos(),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _title(double fontSize) => Text(
        'Gestión de Paralelos',
        style: GoogleFonts.inter(
          color: AppColors.gray002855,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 36 / 30,
          letterSpacing: 0,
        ),
      );
}

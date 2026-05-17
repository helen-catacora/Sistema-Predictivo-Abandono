import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/refresh_button.dart';
import '../providers/gestiones_provider.dart';

class GestionesHeader extends StatelessWidget {
  const GestionesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = Responsive.pageTitleFontSize(constraints.maxWidth);
        final isMobile = Responsive.isMobile(constraints.maxWidth);
        final padding = Responsive.contentPadding(constraints.maxWidth);

        return Padding(
          padding: EdgeInsets.fromLTRB(padding.left, 0 , padding.right, 0),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(fontSize),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RefreshButton(
                        onTap: () => context.read<GestionesProvider>().loadGestiones(),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _title(fontSize)),
                    RefreshButton(
                      onTap: () => context.read<GestionesProvider>().loadGestiones(),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _title(double fontSize) => Text(
        'Períodos de Registro de Estudiantes',
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.gray002855,
          height: 36 / 30,
          letterSpacing: 0,
        ),
      );
}

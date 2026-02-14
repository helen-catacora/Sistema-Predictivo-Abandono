import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Panel izquierdo del login con información del sistema EMI.
class LoginLeftPanel extends StatelessWidget {
  const LoginLeftPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppColors.navyDark,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: compact
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        /*child: Icon(
                          FontAwesomeIcons.shieldHalved,
                          size: 30,
                          color: AppColors.navyDark,
                        ),*/
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network('https://tse1.mm.bing.net/th/id/OIP.rWIa57aBTxT20Yxk3PFouAHaHa?cb=defcache2defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
                          width: 30,
                          height: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EMI',
                            style: GoogleFonts.inter(
                              color: AppColors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 37.5 / 30,
                              letterSpacing: 0.75,
                            ),
                          ),
                          Text(
                            'CIENCIAS BÁSICAS',
                            style: GoogleFonts.inter(
                              color: AppColors.accentYellow,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 20 / 14,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  Text(
                    'Sistema Predictivo del Abandono Estudiantil',
                    style: GoogleFonts.inter(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 45 / 36,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Control de asistencia y detección temprana de posibles casos '
                    'de abandono.',
                    style: GoogleFonts.inter(
                      color: AppColors.whiteD1D5DB,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 29.25 / 18,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LoginFeatureItem(
                      icon: FontAwesomeIcons.solidCalendarCheck,
                      title: 'Control de Asistencia',
                      description:
                          'Registro y seguimiento detallado de la asistencia estudiantil ',
                    ),
                    // const SizedBox(height: 24),
                    LoginFeatureItem(
                      icon: Icons.trending_up_outlined,
                      title: 'Detección de Riesgos',
                      description:
                          'Identificación temprana de estudiantes con posibilidad de '
                          'abandono académico',
                    ),
                    // const SizedBox(height: 24),
                    LoginFeatureItem(
                      icon: Icons.people_alt_rounded,
                      title: 'Gestión Integral',
                      description:
                          'Reportes para la toma de decisiones académicas '
                          'estratégicas',
                    ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  const SizedBox(height: 30),
                  Text(
                    'ESCUELA MILITAR DE INGENIERÍA',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Excelencia Académica • Formación Integral • Liderazgo',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ítem de característica del panel izquierdo.
class LoginFeatureItem extends StatelessWidget {
  const LoginFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.yellowFFD60A.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(99999),
          ),
          child: Icon(icon, color: AppColors.yellowFFD60A, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 28 / 18,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  color: AppColors.gray9CA3AF,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

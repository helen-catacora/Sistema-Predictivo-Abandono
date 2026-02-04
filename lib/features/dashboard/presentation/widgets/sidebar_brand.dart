import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Logo y marca EMI en el sidebar.
class SidebarBrand extends StatelessWidget {
  const SidebarBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FontAwesomeIcons.shieldHalved,
              size: 20,
              color: AppColors.navyDark,
            ),
            /*child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                child: Image.network('https://tse1.mm.bing.net/th/id/OIP.rWIa57aBTxT20Yxk3PFouAHaHa?cb=defcache2defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
                      width: 30,
                      height: 30,
                    ),
            ),*/
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EMI',
                style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 22.5 / 18,
                  letterSpacing: 0.45,
                ),
              ),
              Text(
                'CIENCIAS BÁSICAS',
                style: GoogleFonts.inter(
                  color: AppColors.yellowFFD60A,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 16 / 12,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

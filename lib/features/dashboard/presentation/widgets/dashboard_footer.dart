import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

import '../../../../core/constants/app_colors.dart';

/// Pie de página del panel de control.
class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  Future<void> _abrirEnlace(String url) async {
    web.window.open(
      url, 
      '_blank'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copyrightText = Flexible(
            child: Text(
              '© ${DateTime.now().year} ESCUELA MILITAR DE INGENIERÍA - CIENCIAS BÁSICAS',
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
          final linksRow = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  
                  _abrirEnlace('https://emi.edu.bo/index.php/nosotros/normativa-interna');
                },
                child: Text(
                  'REGLAMENTOS',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  // Reemplaza esta URL con tu enlace real del manual
                  _abrirEnlace('https://drive.google.com/file/d/1KY3DWd2t1Cg8xE8RQXOAJcktr2oGx0ey/view?usp=sharing');
                },
                child: Text(
                  'MANUAL DE USUARIO',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                copyrightText,
                const SizedBox(height: 8),
                linksRow,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              copyrightText,
              linksRow,
            ],
          );
        },
      ),
    );
  }
}

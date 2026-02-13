import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';

class RefreshButton extends StatelessWidget {
  final Function() onTap;
  const RefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.gray002855,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Refrescar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

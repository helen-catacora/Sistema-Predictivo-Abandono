import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImportSectionHeader extends StatelessWidget {
  const ImportSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Color(0xff023E8A),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Color(0xff1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 28 / 18,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

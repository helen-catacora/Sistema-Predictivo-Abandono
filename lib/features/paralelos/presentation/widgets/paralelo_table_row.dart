import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import 'paralelos_helpers.dart';

/// Colores para badge y pill por índice.
const List<Color> _badgeColors = [
  Color(0xFF0EA5E9),
  Color(0xFF9333EA),
  Color(0xFF16A34A),
  Color(0xFFEA580C),
];

/// Una fila de la tabla de paralelos: nombre (badge + texto), área, semestre, encargado, acción.
class ParaleloTableRow extends StatelessWidget {
  const ParaleloTableRow({
    super.key,
    required this.paralelo,
    required this.index,
    this.cantidadEstudiantes,
    required this.onAsignarEncargado,
  });

  final ParaleloItem paralelo;
  final int index;
  final int? cantidadEstudiantes;
  final VoidCallback onAsignarEncargado;

  @override
  Widget build(BuildContext context) {
    final color = _badgeColors[colorIndexForParalelo(index)];
    final areaName = nombreAreaParalelo(paralelo.areaId);
    final hasEncargado = paralelo.nombreEncargado.trim().isNotEmpty;
    final estudiantesText =
        cantidadEstudiantes != null ? '$cantidadEstudiantes estudiantes' : '— estudiantes';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyE2E8F0, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 11,
            child: _cell(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: color.withValues(alpha: 0.2),
                    child: Text(
                      _letraParalelo(paralelo.nombre),
                      style: GoogleFonts.inter(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          paralelo.nombre.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: AppColors.darkBlue1E293B,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          estudiantesText,
                          style: GoogleFonts.inter(
                            color: AppColors.grey64748B,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 7,
            child: _cell(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  areaName.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: _cell(
              child: Text(
                'Semestre ${paralelo.semestreId}',
                style: GoogleFonts.inter(
                  color: AppColors.black334155,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 11,
            child: _cell(
              child: hasEncargado
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.greyE2E8F0,
                          child: Text(
                            _iniciales(paralelo.nombreEncargado),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray002855,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                paralelo.nombreEncargado,
                                style: GoogleFonts.inter(
                                  color: AppColors.darkBlue1E293B,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Encargado',
                                style: GoogleFonts.inter(
                                  color: AppColors.grey64748B,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.greyE2E8F0,
                          child: Icon(
                            Icons.help_outline,
                            size: 18,
                            color: AppColors.grey64748B,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sin asignar',
                              style: GoogleFonts.inter(
                                color: AppColors.grey64748B,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Pendiente',
                              style: GoogleFonts.inter(
                                color: AppColors.grey94A3B8,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: _cell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FilledButton.icon(
                  onPressed: onAsignarEncargado,
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Asignar Encargado'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green16A34A,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: child,
    );
  }

  String _letraParalelo(String nombre) {
    final match = RegExp(r'(\w)').firstMatch(nombre);
    return match?.group(1)?.toUpperCase() ?? '?';
  }

  String _iniciales(String nombre) {
    final parts = nombre.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

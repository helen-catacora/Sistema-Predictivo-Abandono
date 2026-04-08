import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Card con barra de progreso indeterminada durante el entrenamiento.
class EntrenamientoProgressCard extends StatelessWidget {
  const EntrenamientoProgressCard({
    super.key,
    required this.estado,
    required this.nombreArchivo,
    required this.totalRegistros,
  });

  final String estado;
  final String nombreArchivo;
  final int totalRegistros;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          top: BorderSide(color: Color(0xffFFD60A), width: 4),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xffFFD60A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Entrenamiento en Progreso',
                style: GoogleFonts.inter(
                  color: const Color(0xff1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 28 / 18,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: AppColors.greyE2E8F0,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xff002855)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _infoItem('Archivo', nombreArchivo),
              const SizedBox(width: 32),
              _infoItem('Registros', '$totalRegistros'),
              const SizedBox(width: 32),
              _infoItem('Estado', _estadoTexto),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'El sistema está entrenando 3 modelos (Random Forest, XGBoost, Logistic Regression) '
            'con optimización de hiperparámetros. Este proceso puede tardar varios minutos.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xff64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String get _estadoTexto {
    switch (estado) {
      case 'pendiente':
        return 'Preparando...';
      case 'entrenando':
        return 'Entrenando modelos...';
      default:
        return estado;
    }
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xff64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xff1E293B),
          ),
        ),
      ],
    );
  }
}

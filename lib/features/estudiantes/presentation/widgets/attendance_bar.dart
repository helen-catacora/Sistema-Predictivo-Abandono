import 'package:flutter/material.dart';

/// Barra de progreso para porcentaje de asistencia.
/// Colores: rojo (< 70%), amarillo (70-85%), verde (> 85%).
class AttendanceBar extends StatelessWidget {
  const AttendanceBar({super.key, required this.percentage});

  final int percentage;

  Color get _color {
    if (percentage < 50) return const Color(0xFFEF4444);
    if (percentage < 80) return const Color(0xFFFACC15);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$percentage%',
          style: TextStyle(
            color: _color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Indicador de nivel de riesgo (ALTO, MEDIO, BAJO).
enum RiskLevel {
  alto,
  medio,
  bajo;

  static RiskLevel fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ALTO':
        return RiskLevel.alto;
      case 'MEDIO':
        return RiskLevel.medio;
      case 'BAJO':
        return RiskLevel.bajo;
      default:
        return RiskLevel.medio;
    }
  }
}

/// Widget que muestra un punto de color y el nivel de riesgo.
class RiskLevelIndicator extends StatelessWidget {
  const RiskLevelIndicator({super.key, required this.level});

  final RiskLevel level;

  static Color _colorFor(RiskLevel level) {
    switch (level) {
      case RiskLevel.alto:
        return const Color(0xFFEF4444);
      case RiskLevel.medio:
        return const Color(0xFFFACC15);
      case RiskLevel.bajo:
        return const Color(0xFF22C55E);
    }
  }

  static String _labelFor(RiskLevel level) {
    switch (level) {
      case RiskLevel.alto:
        return 'ALTO';
      case RiskLevel.medio:
        return 'MEDIO';
      case RiskLevel.bajo:
        return 'BAJO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(level);
    final label = _labelFor(level);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

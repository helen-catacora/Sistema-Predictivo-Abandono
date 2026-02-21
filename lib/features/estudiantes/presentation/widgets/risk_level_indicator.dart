import 'package:flutter/material.dart';

/// Indicador de nivel de riesgo (ALTO, MEDIO, BAJO).
enum RiskLevel {
  critico,
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
      case 'CRITICO':
        return RiskLevel.critico;
      default:
        return RiskLevel.medio;
    }
  }
}

/// Widget que muestra un punto de color y el nivel de riesgo.
class RiskLevelIndicator extends StatelessWidget {
  const RiskLevelIndicator({super.key, required this.level});

  final RiskLevel level;

  static Color colorFor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critico:
      case RiskLevel.alto:
        return const Color(0xffB91C1C);
      case RiskLevel.medio:
        return const Color(0xffA16207);
      case RiskLevel.bajo:
        return const Color(0xff15803D);
    }
  }

  static Color _dotColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critico:
      case RiskLevel.alto:
        return const Color(0xffDC2626);
      case RiskLevel.medio:
        return const Color(0xffEAB308);
      case RiskLevel.bajo:
        return const Color(0xff22C55E);
    }
  }

  static Color _backGroundColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critico:
      case RiskLevel.alto:
        return const Color(0xffFEF2F2);
      case RiskLevel.medio:
        return const Color(0xffFEFCE8);
      case RiskLevel.bajo:
        return const Color(0xffF0FDF4);
    }
  }

  static Color _borderColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critico:
      case RiskLevel.alto:
        return const Color(0xffFECACA);
      case RiskLevel.medio:
        return const Color(0xffFEF08A);
      case RiskLevel.bajo:
        return const Color(0xffBBF7D0);
    }
  }

  static String _labelFor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critico:
        return 'CRITICO';
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
    final color = colorFor(level);
    final label = _labelFor(level);
    final backGroundColor = _backGroundColor(level);
    final borderColor = _borderColor(level);
    final dotColor = _dotColor(level);

    return Container(
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
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
        ),
      ),
    );
  }
}

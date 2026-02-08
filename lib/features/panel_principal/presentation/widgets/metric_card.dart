import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tarjeta de métrica para el panel principal.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.trendIsPositive = false,
    this.trendColor,
    this.badge,
    this.details,
    this.detailColors,
    this.icon,
    this.topBorderColor,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? trend;
  final bool trendIsPositive;
  /// Si se define, usa este color para el trend en lugar de rojo/verde por defecto.
  final Color? trendColor;
  final String? badge;
  final List<String>? details;
  /// Mismo orden que [details]; si se define, cada línea usa su color.
  final List<Color>? detailColors;
  final IconData? icon;
  /// Borde superior de la tarjeta (ej. rojo para riesgo, amarillo para alertas).
  final Color? topBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: topBorderColor != null
            ? [
                BoxShadow(
                  color: topBorderColor!.withValues(alpha: 0.3),
                  offset: const Offset(0, -1),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topBorderColor != null)
              Container(
                height: 4,
                color: topBorderColor,
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              color: AppColors.navyMedium,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.navyMedium,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badge!,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          if (trend != null) ...[
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  trendIsPositive
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 14,
                                  color: trendColor ??
                                      (trendIsPositive
                                          ? Colors.red
                                          : Colors.green),
                                ),
                                Text(
                                  trend!,
                                  style: TextStyle(
                                    color: trendColor ??
                                        (trendIsPositive
                                            ? Colors.red
                                            : Colors.green),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: AppColors.grayMedium,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (details != null) ...[
                        const SizedBox(height: 8),
                        ...List.generate(details!.length, (i) {
                          final color = detailColors != null &&
                                  i < detailColors!.length
                              ? detailColors![i]
                              : AppColors.grayMedium;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              details![i],
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 48,
                    color: (topBorderColor != null
                            ? topBorderColor!.withValues(alpha: 0.5)
                            : AppColors.grayLight),
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
  ),
  );
  }
}

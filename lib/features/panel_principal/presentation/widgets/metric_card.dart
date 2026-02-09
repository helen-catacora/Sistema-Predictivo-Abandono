import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

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
    this.detailsTitles,
    this.detailsContent,
    this.detailColors,
    this.topBorderColor,
    this.showAsColumn = true,
    required this.iconPath,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? trend;
  final bool trendIsPositive;
  final Color? trendColor;
  final String? badge;
  final List<String>? detailsTitles;
  final List<String>? detailsContent;
  final List<Color>? detailColors;
  final Color? topBorderColor;
  final bool showAsColumn;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: topBorderColor ?? Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(iconPath, width: 96, height: 96),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.grey64748B,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 16 / 12,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        value,
                        style: GoogleFonts.inter(
                          color: AppColors.darkBlue1E293B,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          height: 48 / 48,
                          letterSpacing: 0,
                        ),
                      ),
                      if (badge != null) ...[
                        SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blueDBEAFE,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.inter(
                              color: AppColors.blue1D4ED8,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 16 / 12,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle!,
                                style: GoogleFonts.inter(
                                  color: AppColors.grey94A3B8,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 16 / 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                            if (detailsTitles != null &&
                                detailsTitles!.isNotEmpty &&
                                detailsContent!.isNotEmpty) ...[
                              if (showAsColumn) ...[
                                Row(
                                  spacing: 12,
                                  children: List.generate(
                                    detailsTitles!.length,
                                    (index) {
                                      final title = detailsTitles![index];
                                      final content = detailsContent![index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: GoogleFonts.inter(
                                              color: AppColors.grey94A3B8,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              height: 16 / 12,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          Text(
                                            content,
                                            style: GoogleFonts.inter(
                                              color: AppColors.black334155,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 20 / 14,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ] else
                                Row(
                                  spacing: 20,
                                  children: List.generate(
                                    detailsTitles!.length,
                                    (index) {
                                      final color =
                                          detailColors != null &&
                                              index < detailColors!.length
                                          ? detailColors![index]
                                          : AppColors.grayMedium;
                                      final title = detailsTitles![index];
                                      final content = detailsContent![index];
                                      return Row(
                                        spacing: 2,
                                        children: [
                                          Text(
                                            title,
                                            style: GoogleFonts.inter(
                                              color: AppColors.grey94A3B8,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 16 / 12,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          Text(
                                            content,
                                            style: GoogleFonts.inter(
                                              color: color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

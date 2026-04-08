import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  static ScreenType screenType(double width) {
    if (width < mobileBreakpoint) return ScreenType.mobile;
    if (width < tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= tabletBreakpoint;

  /// Padding adaptivo para contenido principal.
  static EdgeInsets contentPadding(double width) {
    if (width < mobileBreakpoint) return const EdgeInsets.all(12);
    if (width < tabletBreakpoint) return const EdgeInsets.all(16);
    return const EdgeInsets.all(24);
  }

  /// FontSize para títulos de sección (18px desktop → 16px móvil).
  static double titleFontSize(double width) {
    if (width < mobileBreakpoint) return 16;
    if (width < tabletBreakpoint) return 17;
    return 18;
  }

  /// FontSize para subtítulos/labels (14px desktop → 12px móvil).
  static double subtitleFontSize(double width) {
    if (width < mobileBreakpoint) return 12;
    if (width < tabletBreakpoint) return 13;
    return 14;
  }

  /// FontSize para cuerpo de texto (13px desktop → 12px móvil).
  static double bodyFontSize(double width) {
    if (width < mobileBreakpoint) return 12;
    return 13;
  }

  /// FontSize para títulos de página (30px desktop → 22px móvil).
  static double pageTitleFontSize(double width) {
    if (width < mobileBreakpoint) return 22;
    if (width < tabletBreakpoint) return 26;
    return 30;
  }
}

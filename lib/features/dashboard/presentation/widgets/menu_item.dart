import 'package:flutter/material.dart';

/// Modelo de ítem del menú lateral.
class MenuItem {
  const MenuItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  final String path;
  final String label;
  final IconData icon;
  final bool isSelected;
}

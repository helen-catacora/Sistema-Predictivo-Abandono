import 'package:flutter/material.dart';

/// Modelo de ítem del menú lateral.
class MenuItem {
  const MenuItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.children = const [],
  });

  final String path;
  final String label;
  final IconData icon;
  final bool isSelected;
  final List<MenuItem> children;

  bool get hasChildren => children.isNotEmpty;
}

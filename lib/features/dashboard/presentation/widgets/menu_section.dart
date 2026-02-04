import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'menu_item.dart';
import 'sidebar_tile.dart';

/// Sección del menú lateral con título e ítems.
class MenuSection extends StatelessWidget {
  const MenuSection({super.key, required this.title, required this.items});

  final String title;
  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ...items.map((item) => SidebarTile(item: item)),
        ],
      ),
    );
  }
}

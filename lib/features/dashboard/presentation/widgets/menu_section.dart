import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/features/dashboard/presentation/widgets/sidebar_expantion_tile.dart';

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
          ...items.map(
            (item) => item.hasChildren
                ? SidebarExpansionTile(item: item)
                : SidebarTile(item: item),
          ),
        ],
      ),
    );
  }
}

class SidebarSectionExpansionTile extends StatelessWidget {
  const SidebarSectionExpansionTile({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
  });

  final String title;
  final IconData icon;
  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          childrenPadding: const EdgeInsets.only(left: 8, bottom: 8),
          leading: Icon(icon, color: AppColors.white, size: 22),
          title: Text(
            title,
            // style: TextStyle(
            //   color: AppColors.white.withValues(alpha: 0.9),
            //   fontSize: 13,
            //   fontWeight: FontWeight.w600,
            //   letterSpacing: 1.1,
            // ),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          iconColor: AppColors.white,
          collapsedIconColor: AppColors.white.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          children: items.map((item) => SidebarTile(item: item)).toList(),
        ),
      ),
    );
  }
}

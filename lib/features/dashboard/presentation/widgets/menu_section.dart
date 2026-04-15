import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:sistemapredictivoabandono/features/dashboard/presentation/widgets/sidebar_expantion_tile.dart';

import '../../../../core/constants/app_colors.dart';
import 'menu_item.dart';
import 'sidebar_tile.dart';

/// Sección del menú lateral con título e ítems.
class MenuSection extends StatelessWidget {
  const MenuSection({
    super.key,
    required this.title,
    required this.items,
    this.isCollapsed = false,
    this.onNavigated,
  });

  final String title;
  final List<MenuItem> items;
  final bool isCollapsed;
  final VoidCallback? onNavigated;

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Column(
        children: items
            .map((item) => SidebarTile(item: item, isCollapsed: true, onNavigated: onNavigated))
            .toList(),
      );
    }
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
                ? SidebarExpansionTile(item: item, onNavigated: onNavigated)
                : SidebarTile(item: item, onNavigated: onNavigated),
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
    this.isCollapsed = false,
    this.onNavigated,
    this.onExpand,
  });

  final String title;
  final IconData icon;
  final List<MenuItem> items;
  final bool isCollapsed;
  final VoidCallback? onNavigated;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      // En modo colapsado, mostrar solo el icono de la sección con tooltip
      final hasSelectedChild = items.any((item) => item.isSelected);
      return Tooltip(
        message: title,
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onExpand?.call();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: hasSelectedChild
                      ? const Border(
                          left: BorderSide(
                            color: AppColors.accentYellow,
                            width: 3,
                          ),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: AppColors.white, size: 22),
                ),
              ),
            ),
          ),
        ),
      );
    }

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
          children: items.map((item) => item.hasChildren
              ? SidebarExpansionTile(item: item, onNavigated: onNavigated)
              : SidebarTile(item: item, onNavigated: onNavigated)).toList(),
        ),
      ),
    );
  }
}

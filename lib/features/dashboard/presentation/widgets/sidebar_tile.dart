import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import 'menu_item.dart';

/// Ítem individual del menú lateral.
class SidebarTile extends StatelessWidget {
  const SidebarTile({
    super.key,
    required this.item,
    this.isCollapsed = false,
    this.onNavigated,
  });

  final MenuItem item;
  final bool isCollapsed;
  final VoidCallback? onNavigated;

  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
              context.go(item.path);
              onNavigated?.call();
            },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: item.isSelected
                  ? const Border(
                      left: BorderSide(color: AppColors.accentYellow, width: 3),
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isCollapsed
                ? Center(
                    child: Icon(
                      item.icon,
                      size: 22,
                      color: AppColors.white,
                    ),
                  )
                : Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: item.isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: item.label,
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 300),
        child: tile,
      );
    }
    return tile;
  }
}

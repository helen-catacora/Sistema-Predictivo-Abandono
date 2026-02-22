import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/features/dashboard/presentation/widgets/menu_item.dart';
import 'package:sistemapredictivoabandono/features/dashboard/presentation/widgets/sidebar_tile.dart';

class SidebarExpansionTile extends StatefulWidget {
  const SidebarExpansionTile({super.key, required this.item});

  final MenuItem item;

  @override
  State<SidebarExpansionTile> createState() => _SidebarExpansionTileState();
}

class _SidebarExpansionTileState extends State<SidebarExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.item.children.any((c) => c.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(widget.item.label),
          initiallyExpanded: false,
          onExpansionChanged: (value) {
            setState(() => _isExpanded = value);
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          leading: Icon(widget.item.icon, color: AppColors.white, size: 22),
          title: Text(
            widget.item.label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: _isExpanded ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          iconColor: AppColors.white,
          collapsedIconColor: AppColors.white.withValues(alpha: 0.6),
          children: widget.item.children
              .map((child) => SidebarTile(item: child))
              .toList(),
        ),
      ),
    );
  }
}

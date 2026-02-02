import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import 'app_sidebar.dart';
import '../widgets/dashboard_footer.dart';
import '../widgets/dashboard_header.dart';

/// Layout principal con menú lateral y área de contenido.
class DashboardLayout extends StatelessWidget {
  const DashboardLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebar(selectedPath: location),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DashboardHeader(),
                Expanded(
                  child: Container(
                    color: AppColors.grayLight,
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
                const DashboardFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

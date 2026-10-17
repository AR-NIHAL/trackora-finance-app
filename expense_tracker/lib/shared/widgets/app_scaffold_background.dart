import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Wraps a scaffold or screen in a subtle dark mode gradient background.
/// On light mode, it transparently passes through the child to preserve the light scaffold background.
class AppScaffoldBackground extends StatelessWidget {
  final Widget child;

  const AppScaffoldBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) return child;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.darkBackgroundGradient,
      ),
      child: child,
    );
  }
}

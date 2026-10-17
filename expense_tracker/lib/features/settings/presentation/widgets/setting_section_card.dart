import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsSectionCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: _withDividers(children, context)),
    );
  }

  List<Widget> _withDividers(List<Widget> items, BuildContext context) {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      widgets.add(items[i]);

      if (i != items.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.cardBorder(context),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

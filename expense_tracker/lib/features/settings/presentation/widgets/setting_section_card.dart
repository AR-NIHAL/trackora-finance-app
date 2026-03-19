import 'package:flutter/material.dart';

class SettingsSectionCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.06),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

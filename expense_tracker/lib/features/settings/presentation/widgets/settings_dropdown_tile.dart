import 'package:flutter/material.dart';

class SettingsDropdownTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const SettingsDropdownTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: theme.colorScheme.secondaryContainer,
        ),
        child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          borderRadius: BorderRadius.circular(16),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged ?? (_) {},
        ),
      ),
    );
  }
}

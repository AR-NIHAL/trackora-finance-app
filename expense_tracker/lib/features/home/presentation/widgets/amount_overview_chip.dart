import 'package:flutter/material.dart';

class AmountOverviewChip extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color? accentColor;

  const AmountOverviewChip({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : (accentColor != null
                ? accentColor!.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor != null
                  ? accentColor!.withValues(alpha: isDark ? 0.22 : 0.12)
                  : theme.colorScheme.surface,
            ),
            child: Icon(
              icon,
              size: 18,
              color: accentColor ?? theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: accentColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

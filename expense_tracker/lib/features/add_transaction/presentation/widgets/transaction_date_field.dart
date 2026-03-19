import 'package:flutter/material.dart';

class TransactionDateField extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDateField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

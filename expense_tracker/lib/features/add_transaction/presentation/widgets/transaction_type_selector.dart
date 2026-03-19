import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          Expanded(
            child: _TypeOption(
              label: 'Expense',
              icon: Icons.arrow_upward_rounded,
              isSelected: true,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _TypeOption(
              label: 'Income',
              icon: Icons.arrow_downward_rounded,
              isSelected: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _TypeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

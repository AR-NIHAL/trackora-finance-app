import 'package:flutter/material.dart';

class AboutAppCard extends StatelessWidget {
  const AboutAppCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Expense Tracker',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Version 1.0.0',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.78,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A clean and modern personal finance app to track spending, manage budgets, and view insights.',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

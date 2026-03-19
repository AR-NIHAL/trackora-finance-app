import 'package:flutter/material.dart';
import 'amount_overview_chip.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.75,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$12,450.00',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: AmountOverviewChip(
                  title: 'Month Income',
                  amount: '\$8,240.00',
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AmountOverviewChip(
                  title: 'Month Expense',
                  amount: '\$3,180.00',
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

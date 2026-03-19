import 'package:flutter/material.dart';
import '../../providers/budget_provider.dart';
import 'budget_progress_bar.dart';

class BudgetCard extends StatelessWidget {
  final BudgetStatusItem item;
  final VoidCallback? onDelete;

  const BudgetCard({super.key, required this.item, this.onDelete});

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final budget = item.budget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: item.isExceeded
                    ? Colors.red.withValues(alpha: 0.12)
                    : Colors.teal.withValues(alpha: 0.12),
                child: Icon(
                  item.isExceeded
                      ? Icons.warning_amber_rounded
                      : Icons.account_balance_wallet_outlined,
                  color: item.isExceeded ? Colors.red : Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.category,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Limit: ৳ ${_formatAmount(budget.limitAmount)}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 16),
          BudgetProgressBar(
            progress: item.progress,
            isExceeded: item.isExceeded,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Spent: ৳ ${_formatAmount(item.spentAmount)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.isExceeded
                      ? 'Exceeded by ৳ ${_formatAmount(item.spentAmount - budget.limitAmount)}'
                      : 'Remaining: ৳ ${_formatAmount(item.remainingAmount)}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: item.isExceeded ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

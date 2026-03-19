import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../providers/budget_provider.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_form_dialog.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  Future<void> _openBudgetDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const BudgetFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetItems = ref.watch(budgetStatusListProvider);
    final totalLimit = ref.watch(totalBudgetLimitProvider);
    final totalSpent = ref.watch(totalBudgetSpentProvider);
    final totalRemaining = ref.watch(totalBudgetRemainingProvider);

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Budget Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _openBudgetDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Set category budgets and track spending progress',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
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
                const Text(
                  'Overall Budget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _OverviewItem(
                        label: 'Total Limit',
                        value: '৳ ${_formatAmount(totalLimit)}',
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _OverviewItem(
                        label: 'Spent',
                        value: '৳ ${_formatAmount(totalSpent)}',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _OverviewItem(
                  label: 'Remaining',
                  value: '৳ ${_formatAmount(totalRemaining)}',
                  color: totalRemaining < 0 ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: budgetItems.isEmpty
                ? Center(
                    child: Text(
                      'No budgets added yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: budgetItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = budgetItems[index];

                      return BudgetCard(
                        item: item,
                        onDelete: () {
                          ref
                              .read(budgetProvider.notifier)
                              .deleteBudget(item.budget.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OverviewItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

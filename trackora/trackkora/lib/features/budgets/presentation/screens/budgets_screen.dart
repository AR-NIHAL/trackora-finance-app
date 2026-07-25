import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:trackkora/features/budgets/domain/entities/budget.dart';
import 'package:trackkora/features/budgets/presentation/providers/budget_providers.dart';
import 'package:trackkora/features/budgets/presentation/widgets/budget_card.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/core/utils/currency_utils.dart';

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final budgetsAsync = ref.watch(monthlyBudgetsProvider(_currentMonth));
    final summaryAsync = ref.watch(monthlyBudgetSummaryProvider(_currentMonth));

    return Scaffold(
      appBar: AppBar(
        title: Text('Budgets - ${_formatMonth(_currentMonth)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _currentMonth =
                  DateTime(_currentMonth.year, _currentMonth.month - 1);
            }),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _currentMonth =
                  DateTime(_currentMonth.year, _currentMonth.month + 1);
            }),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBudgetDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          summaryAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (summary) {
              if (summary.totalBudgeted == 0) return const SizedBox.shrink();
              return _BudgetSummaryHeader(summary: summary);
            },
          ),
          Expanded(
            child: budgetsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (budgets) {
                if (budgets.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.savings, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No budgets for this month',
                            style:
                                TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('Tap + to add a budget',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    return BudgetCard(
                      budget: budget,
                      onTap: () => _showEditBudgetDialog(context, budget),
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Budget'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          ref.read(budgetActionsProvider).delete(budget.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatMonth(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showAddBudgetDialog(BuildContext context) {
    final amountController = TextEditingController();
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final categoriesAsync = ref.watch(categoriesProvider);

          return AlertDialog(
            title: const Text('Add Budget'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                categoriesAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                  data: (categories) {
                    final existingBudgets =
                        ref.watch(monthlyBudgetsProvider(_currentMonth));
                    final existingCategoryIds = existingBudgets.whenOrNull(
                          data: (b) => b.map((b) => b.categoryId).toList(),
                        ) ??
                        [];

                    final available = categories
                        .where((c) => !existingCategoryIds.contains(c.id))
                        .toList();

                    if (available.isEmpty) {
                      return const Text(
                          'All categories have budgets for this month');
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: available.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              Icon(
                                IconData(c.iconCodePoint,
                                    fontFamily: 'MaterialIcons'),
                                color: Color(c.colorValue),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(c.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setDialogState(() => selectedCategoryId = value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Budget Amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (selectedCategoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a category')),
                    );
                    return;
                  }
                  final amount = double.tryParse(amountController.text);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid amount')),
                    );
                    return;
                  }

                  final budget = Budget(
                    id: const Uuid().v4(),
                    categoryId: selectedCategoryId!,
                    amount: amount,
                    month: DateTime(_currentMonth.year, _currentMonth.month),
                  );

                  ref.read(budgetActionsProvider).add(budget);
                  Navigator.pop(dialogContext);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, Budget budget) {
    final amountController =
        TextEditingController(text: budget.amount.toStringAsFixed(2));

    final categoriesAsync = ref.read(categoriesProvider);
    final category = categoriesAsync.whenOrNull(
      data: (categories) => categories.firstWhere(
        (c) => c.id == budget.categoryId,
        orElse: () => categories.first,
      ),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category != null)
              ListTile(
                leading: Icon(
                  IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: Color(category.colorValue),
                ),
                title: Text(category.name),
                subtitle: const Text('Category'),
                contentPadding: EdgeInsets.zero,
              ),
            const SizedBox(height: 8),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter a valid amount')),
                );
                return;
              }

              final updated = budget.copyWith(amount: amount);
              ref.read(budgetActionsProvider).update(updated);
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _BudgetSummaryHeader extends StatelessWidget {
  final BudgetSummary summary;
  const _BudgetSummaryHeader({required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = summary.remaining;
    final remainingColor = remaining >= 0 ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryStat(
              label: 'Budgeted',
              amount: summary.totalBudgeted,
              color: Theme.of(context).colorScheme.primary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SummaryStat(
              label: 'Spent',
              amount: summary.totalSpent,
              color: Colors.orange,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SummaryStat(
              label: 'Remaining',
              amount: remaining.abs(),
              color: remainingColor,
              isDark: isDark,
              prefix: remaining >= 0 ? '' : '-',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;
  final String prefix;

  const _SummaryStat({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$prefix${CurrencyUtils.format(amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

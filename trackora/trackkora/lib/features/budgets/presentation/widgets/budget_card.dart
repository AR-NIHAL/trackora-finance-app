import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/budgets/domain/entities/budget.dart';
import 'package:trackkora/features/budgets/presentation/providers/budget_providers.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/core/utils/currency_utils.dart';

class BudgetCard extends ConsumerWidget {
  final Budget budget;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spentAsync = ref.watch(budgetSpentProvider(budget));
    final categoriesAsync = ref.watch(categoriesProvider);

    return spentAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LinearProgressIndicator(),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $e'),
        ),
      ),
      data: (spent) {
        final ratio = budget.amount > 0 ? spent / budget.amount : 0.0;
        final percentage = ratio.clamp(0.0, 1.0);
        final isOver = spent > budget.amount;
        final isWarning = !isOver && ratio >= 0.8;

        final Color progressColor;
        if (isOver) {
          progressColor = Colors.red;
        } else if (isWarning) {
          progressColor = Colors.orange;
        } else {
          progressColor = Colors.green;
        }

        final String statusText;
        final Color statusColor;
        if (isOver) {
          statusText = 'Over budget by ${CurrencyUtils.format(spent - budget.amount)}';
          statusColor = Colors.red;
        } else if (isWarning) {
          statusText = 'Almost at limit — ${CurrencyUtils.format(budget.amount - spent)} left';
          statusColor = Colors.orange;
        } else {
          statusText = '${CurrencyUtils.format(budget.amount - spent)} remaining';
          statusColor = Colors.grey;
        }

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: categoriesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (categories) {
                  final category = categories.firstWhere(
                    (c) => c.id == budget.categoryId,
                    orElse: () => categories.first,
                  );
                  final icon = IconData(category.iconCodePoint,
                      fontFamily: 'MaterialIcons');
                  final color = Color(category.colorValue);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.withValues(alpha: 0.2),
                            child: Icon(icon, color: color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${CurrencyUtils.format(spent)} / ${CurrencyUtils.format(budget.amount)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(percentage * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: progressColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') onDelete();
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.grey.shade300,
                          color: progressColor,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

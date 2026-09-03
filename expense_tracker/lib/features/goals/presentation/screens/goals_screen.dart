import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/goals/presentation/widgets/contribute_dialog.dart';
import 'package:expense_tracker/features/goals/presentation/widgets/goal_form_dialog.dart';
import 'package:expense_tracker/features/goals/state/goal_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    SavingGoal? existing,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => GoalFormDialog(existingGoal: existing),
    );
    if (result != null) {
      if (existing == null) {
        ref.read(goalProvider.notifier).addGoal(result);
      } else {
        ref.read(goalProvider.notifier).updateGoal(result);
      }
    }
  }

  Future<void> _openContribute(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => ContributeDialog(goalName: name),
    );
    if (amount != null) {
      ref.read(goalProvider.notifier).contribute(id, amount);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goals = ref.watch(goalProvider).goals;
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Saving Goals')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
      body: goals.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Set a goal like an emergency fund or a vacation, then track your progress here.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: goals.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  goal.deadline == null
                                      ? 'No deadline'
                                      : 'Target: ${AppUtils.formatFullDate(goal.deadline!)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openForm(context, ref, existing: goal);
                              }
                              if (value == 'delete') {
                                ref.read(goalProvider.notifier).deleteGoal(goal.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: goal.progress,
                                  strokeWidth: 6,
                                  color: goal.isCompleted
                                      ? AppColors.income(context)
                                      : theme.colorScheme.primary,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                ),
                                Text(
                                  '${(goal.progress * 100).round()}%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppUtils.formatCurrency(goal.savedAmount, currencyCode)} saved',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppUtils.formatCurrency(goal.remainingAmount, currencyCode)} to go',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _openContribute(
                                context,
                                ref,
                                goal.id,
                                goal.name,
                              ),
                              child: const Text('Contribute'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final amount = await showDialog<double>(
                                  context: context,
                                  builder: (context) => ContributeDialog(
                                    goalName: goal.name,
                                    isWithdraw: true,
                                  ),
                                );
                                if (amount != null) {
                                  ref
                                      .read(goalProvider.notifier)
                                      .withdraw(goal.id, amount);
                                }
                              },
                              child: const Text('Withdraw'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

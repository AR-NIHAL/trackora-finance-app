import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/recurring/presentation/providers/recurring_providers.dart';
import 'package:trackkora/core/utils/currency_utils.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(recurringTransactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
      ),
      body: recurringAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (recurring) {
          if (recurring.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.repeat, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No recurring transactions', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Tap + to add one', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (categories) {
              final categoryMap = {for (final c in categories) c.id: c};
              return _RecurringList(
                recurring: recurring,
                categoryMap: categoryMap,
                ref: ref,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-recurring'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RecurringList extends StatelessWidget {
  final List<RecurringTransaction> recurring;
  final Map<String, dynamic> categoryMap;
  final WidgetRef ref;

  const _RecurringList({
    required this.recurring,
    required this.categoryMap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: recurring.length,
      itemBuilder: (context, index) {
        final item = recurring[index];
        final category = categoryMap[item.categoryId];
        final isIncome = item.type.isIncome;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category != null
                  ? Color(category.colorValue).withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              child: category != null
                  ? Icon(
                      IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                      color: Color(category.colorValue),
                      size: 20,
                    )
                  : const Icon(Icons.category, size: 20),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${_frequencyLabel(item.frequency)} \u2022 ${category?.name ?? "Unknown"}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyUtils.formatWithSign(item.amount, isIncome: isIncome),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () => context.push('/add-recurring/${item.id}'),
            onLongPress: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Recurring Transaction'),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                ref.read(recurringActionsProvider).delete(item.id);
              }
            },
          ),
        );
      },
    );
  }

  String _frequencyLabel(RecurringFrequency frequency) {
    switch (frequency) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }
}

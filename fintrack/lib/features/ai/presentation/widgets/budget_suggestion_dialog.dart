import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../budget/data/models/budget_model.dart';
import '../../../budget/providers/budget_provider.dart';
import '../../providers/budget_suggestion_provider.dart';

class BudgetSuggestionDialog extends ConsumerWidget {
  const BudgetSuggestionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(budgetSuggestionProvider);

    if (suggestions.isEmpty) {
      return AlertDialog(
        title: const Text('Budget Suggestions'),
        content: const Text('No expense data found. Add some transactions first.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Suggested Budgets'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on your spending over the last 3 months',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...suggestions.entries.map((entry) => _SuggestionRow(
              category: entry.key,
              amount: entry.value,
            )),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suggestions include a 15% buffer above your average monthly spending.',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => _applyAll(context, ref, suggestions),
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Apply All'),
        ),
      ],
    );
  }

  Future<void> _applyAll(
    BuildContext context,
    WidgetRef ref,
    Map<String, double> suggestions,
  ) async {
    final budgetNotifier = ref.read(budgetProvider.notifier);

    for (final entry in suggestions.entries) {
      final budget = BudgetModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        category: entry.key,
        limitAmount: entry.value,
        createdAt: DateTime.now(),
      );

      await budgetNotifier.addBudget(budget);
    }

    if (!context.mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget suggestions applied successfully')),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  final String category;
  final double amount;

  const _SuggestionRow({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.teal.withValues(alpha: 0.12),
            child: const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text(
            '৳ ${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

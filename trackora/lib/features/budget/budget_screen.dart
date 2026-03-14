import 'package:flutter/material.dart';
import 'package:trackora/core/services/app_settings.dart';
import 'package:trackora/features/add_transaction/transaction_store.dart';
import 'package:trackora/shared/widgets/summary_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: AppSettings.budgetNotifier.value == 0
          ? ''
          : AppSettings.budgetNotifier.value.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    final value = double.tryParse(_budgetController.text.trim()) ?? 0;
    await AppSettings.setMonthlyBudget(value);
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Monthly budget saved')));
  }

  @override
  Widget build(BuildContext context) {
    final budget = AppSettings.budgetNotifier.value;
    final spent = TransactionStore.currentMonthExpense;
    final remaining = budget - spent;
    final progress = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);

    String statusText = 'Set a budget to track monthly spending.';
    Color statusColor = Colors.blue;

    if (budget > 0) {
      if (spent >= budget) {
        statusText = 'You have crossed your monthly budget.';
        statusColor = Colors.red;
      } else if (spent >= budget * 0.8) {
        statusText = 'Warning: you already used more than 80% of your budget.';
        statusColor = Colors.orange;
      } else {
        statusText = 'Great! Your spending is under control.';
        statusColor = Colors.green;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _budgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monthly Budget',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveBudget,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Budget'),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Budget',
                  amount: budget == 0
                      ? 'Not Set'
                      : '৳ ${budget.toStringAsFixed(0)}',
                  bgColor: Colors.blue.shade50,
                  textColor: Colors.blue,
                  icon: Icons.savings_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Spent',
                  amount: '৳ ${spent.toStringAsFixed(0)}',
                  bgColor: Colors.red.shade50,
                  textColor: Colors.red,
                  icon: Icons.money_off_csred_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: 'Remaining',
            amount: budget == 0
                ? 'Not Set'
                : '৳ ${remaining.toStringAsFixed(0)}',
            bgColor: Colors.green.shade50,
            textColor: Colors.green,
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            borderRadius: BorderRadius.circular(100),
          ),
          const SizedBox(height: 14),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

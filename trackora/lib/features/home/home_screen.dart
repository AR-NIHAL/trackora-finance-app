import 'package:flutter/material.dart';
import 'package:trackora/core/services/app_settings.dart';
import 'package:trackora/features/add_transaction/transaction_store.dart';
import 'package:trackora/shared/widgets/empty_state_card.dart';
import 'package:trackora/shared/widgets/summary_card.dart';
import 'package:trackora/shared/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';
  String _selectedType = 'All';
  String _selectedCategory = 'All';

  Future<void> _deleteItem(String id) async {
    await TransactionStore.deleteTransaction(id);
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Transaction deleted')));
  }

  Future<void> _showDeleteDialog(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteItem(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = TransactionStore.totalBalance;
    final currentMonthIncome = TransactionStore.currentMonthIncome;
    final currentMonthExpense = TransactionStore.currentMonthExpense;
    final todayExpense = TransactionStore.todayExpense;
    final topCategory = TransactionStore.topExpenseCategory;
    final budget = AppSettings.budgetNotifier.value;
    final budgetLeft = budget - currentMonthExpense;

    final allCategories = ['All', ...TransactionStore.allCategories];

    final transactions = TransactionStore.filteredTransactions(
      query: _search,
      type: _selectedType,
      category: _selectedCategory,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Trackora Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳ ${totalBalance.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Top category this month: $topCategory',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Month Income',
                    amount: '৳ ${currentMonthIncome.toStringAsFixed(0)}',
                    bgColor: Colors.green.shade50,
                    textColor: Colors.green,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Month Expense',
                    amount: '৳ ${currentMonthExpense.toStringAsFixed(0)}',
                    bgColor: Colors.red.shade50,
                    textColor: Colors.red,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Today Expense',
                    amount: '৳ ${todayExpense.toStringAsFixed(0)}',
                    bgColor: Colors.orange.shade50,
                    textColor: Colors.orange,
                    icon: Icons.today,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Budget Left',
                    amount: budget > 0
                        ? '৳ ${budgetLeft.toStringAsFixed(0)}'
                        : 'Not Set',
                    bgColor: Colors.purple.shade50,
                    textColor: Colors.purple,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by note or category',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text('Expense'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: allCategories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Transactions (${transactions.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              const EmptyStateCard(
                message:
                    'No transactions found.\nTry adding or changing filters.',
              )
            else
              ...transactions.map(
                (item) => TransactionCard(
                  item: item,
                  onLongPress: () => _showDeleteDialog(item.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trackora/core/services/app_settings.dart';
import 'package:trackora/features/add_transaction/transaction_model.dart';
import 'package:trackora/features/add_transaction/transaction_store.dart';
import 'package:trackora/widgets/empty_state_card.dart';
import 'package:trackora/widgets/summary_card.dart';
import 'package:trackora/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';
  String _selectedType = 'All';
  String _selectedCategory = 'All';

  bool _isLoading = true;

  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  List<String> _allCategories = ['All'];

  double _totalBalance = 0;
  double _currentMonthIncome = 0;
  double _currentMonthExpense = 0;
  double _todayExpense = 0;
  String _topCategory = 'No data';

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final transactions = await TransactionStore.getTransactions();
    final now = DateTime.now();

    double totalIncome = 0;
    double totalExpense = 0;
    double monthIncome = 0;
    double monthExpense = 0;
    double todayExpense = 0;

    final Set<String> categories = {'All'};
    final Map<String, double> monthCategoryExpense = {};

    bool isSameMonth(DateTime date) {
      return date.year == now.year && date.month == now.month;
    }

    bool isSameDay(DateTime date) {
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    for (final item in transactions) {
      categories.add(item.category);

      if (item.type == 'Income') {
        totalIncome += item.amount;
      } else if (item.type == 'Expense') {
        totalExpense += item.amount;
      }

      if (isSameMonth(item.date)) {
        if (item.type == 'Income') {
          monthIncome += item.amount;
        } else if (item.type == 'Expense') {
          monthExpense += item.amount;
          monthCategoryExpense[item.category] =
              (monthCategoryExpense[item.category] ?? 0) + item.amount;
        }
      }

      if (item.type == 'Expense' && isSameDay(item.date)) {
        todayExpense += item.amount;
      }
    }

    String topCategory = 'No data';
    if (monthCategoryExpense.isNotEmpty) {
      final sorted = monthCategoryExpense.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topCategory = sorted.first.key;
    }

    if (!mounted) return;

    setState(() {
      _allTransactions = transactions;
      _allCategories = categories.toList()..sort();
      _totalBalance = totalIncome - totalExpense;
      _currentMonthIncome = monthIncome;
      _currentMonthExpense = monthExpense;
      _todayExpense = todayExpense;
      _topCategory = topCategory;
      _isLoading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    final filtered = _allTransactions.where((item) {
      final matchesQuery =
          _search.isEmpty ||
          item.note.toLowerCase().contains(_search.toLowerCase()) ||
          item.category.toLowerCase().contains(_search.toLowerCase());

      final matchesType = _selectedType == 'All' || item.type == _selectedType;
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;

      return matchesQuery && matchesType && matchesCategory;
    }).toList();

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  Future<void> _deleteItem(String id) async {
    await TransactionStore.deleteTransaction(id);
    await _loadHomeData();

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
    final budget = AppSettings.budgetNotifier.value;
    final budgetLeft = budget - _currentMonthExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Trackora Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHomeData,
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
                          '৳ ${_totalBalance.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Top category this month: $_topCategory',
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
                          amount: '৳ ${_currentMonthIncome.toStringAsFixed(0)}',
                          bgColor: Colors.green.shade50,
                          textColor: Colors.green,
                          icon: Icons.arrow_downward,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Month Expense',
                          amount:
                              '৳ ${_currentMonthExpense.toStringAsFixed(0)}',
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
                          amount: '৳ ${_todayExpense.toStringAsFixed(0)}',
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
                      _search = value;
                      _applyFilters();
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
                            DropdownMenuItem(
                              value: 'Income',
                              child: Text('Income'),
                            ),
                            DropdownMenuItem(
                              value: 'Expense',
                              child: Text('Expense'),
                            ),
                          ],
                          onChanged: (value) {
                            _selectedType = value!;
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: _allCategories
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (value) {
                            _selectedCategory = value!;
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Transactions (${_filteredTransactions.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_filteredTransactions.isEmpty)
                    const EmptyStateCard(
                      message:
                          'No transactions found.\nTry adding or changing filters.',
                    )
                  else
                    ..._filteredTransactions.map(
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

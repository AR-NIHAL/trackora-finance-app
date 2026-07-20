import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/core/utils/currency_utils.dart';
import 'package:trackkora/core/utils/date_utils.dart' as app_date;
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);

    final incomeAsync = ref.watch(monthlyIncomeProvider(month));
    final expenseAsync = ref.watch(monthlyExpenseProvider(month));
    final transactionsAsync = ref.watch(monthlyTransactionsProvider(month));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(monthlyIncomeProvider);
          ref.invalidate(monthlyExpenseProvider);
          ref.invalidate(monthlyTransactionsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Month Header
            Text(
              app_date.DateUtils.formatMonthYear(now),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Summary Cards
            _SummaryCards(
              incomeAsync: incomeAsync,
              expenseAsync: expenseAsync,
            ),
            const SizedBox(height: 24),

            // Category Breakdown
            categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (categories) {
                return transactionsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (transactions) {
                    if (transactions.isEmpty) return const SizedBox.shrink();
                    final categoryMap = {for (final c in categories) c.id: c};
                    final expenseTransactions = transactions
                        .where((t) => t.type == TransactionType.expense)
                        .toList();

                    if (expenseTransactions.isEmpty) return const SizedBox.shrink();

                    // Calculate totals per category
                    final Map<String, double> categoryTotals = {};
                    for (final t in expenseTransactions) {
                      categoryTotals[t.categoryId] =
                          (categoryTotals[t.categoryId] ?? 0) + t.amount;
                    }

                    final totalExpense = categoryTotals.values.fold(0.0, (a, b) => a + b);

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense Breakdown',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: categoryTotals.entries.map((e) {
                                    final category = categoryMap[e.key];
                                    final percentage = (e.value / totalExpense * 100);
                                    return PieChartSectionData(
                                      value: e.value,
                                      color: category != null
                                          ? Color(category.colorValue)
                                          : Colors.grey,
                                      title: '${percentage.toStringAsFixed(0)}%',
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Legend
                            ...categoryTotals.entries.map((e) {
                              final category = categoryMap[e.key];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: category != null
                                            ? Color(category.colorValue)
                                            : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(category?.name ?? 'Unknown'),
                                    ),
                                    Text(
                                      CurrencyUtils.format(e.value),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            transactionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (transactions) {
                if (transactions.isEmpty) return const SizedBox.shrink();
                final recent = transactions.take(5).toList();
                return categoriesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (categories) {
                    final categoryMap = {for (final c in categories) c.id: c};
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Transactions',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextButton(
                                  onPressed: () => context.go('/transactions'),
                                  child: const Text('See All'),
                                ),
                              ],
                            ),
                          ),
                          ...recent.map((t) {
                            final category = categoryMap[t.categoryId];
                            final isIncome = t.type == TransactionType.income;
                            return ListTile(
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
                              title: Text(t.title),
                              subtitle: Text(
                                '${category?.name ?? "Unknown"} - ${app_date.DateUtils.formatDate(t.date)}',
                              ),
                              trailing: Text(
                                CurrencyUtils.formatWithSign(t.amount, isIncome: isIncome),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final AsyncValue<double> incomeAsync;
  final AsyncValue<double> expenseAsync;

  const _SummaryCards({
    required this.incomeAsync,
    required this.expenseAsync,
  });

  @override
  Widget build(BuildContext context) {
    final income = incomeAsync.valueOrNull ?? 0;
    final expense = expenseAsync.valueOrNull ?? 0;
    final balance = income - expense;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Income',
            amount: income,
            color: Colors.green,
            icon: Icons.arrow_upward,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Expenses',
            amount: expense,
            color: Colors.red,
            icon: Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Balance',
            amount: balance,
            color: balance >= 0 ? Colors.blue : Colors.orange,
            icon: Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyUtils.formatCompact(amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(monthlyIncomeProvider);
            ref.invalidate(monthlyExpenseProvider);
            ref.invalidate(monthlyTransactionsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.push('/search'),
                ),
              ),
              Text(
                app_date.DateUtils.formatMonthYear(now),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _SummaryCards(
                incomeAsync: incomeAsync,
                expenseAsync: expenseAsync,
              ),
              const SizedBox(height: 24),
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

    return Column(
      children: [
        // Income & Expense side by side
        Row(
          children: [
            Expanded(
              child: _GlassSummaryCard(
                title: 'Income',
                amount: income,
                gradientColors: const [Color(0xFF00C853), Color(0xFF00E676)],
                icon: Icons.arrow_downward_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassSummaryCard(
                title: 'Expenses',
                amount: expense,
                gradientColors: const [Color(0xFFFF1744), Color(0xFFFF5252)],
                icon: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Balance full width
        _GlassBalanceCard(
          amount: balance,
          isPositive: balance >= 0,
        ),
      ],
    );
  }
}

class _GlassSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final List<Color> gradientColors;
  final IconData icon;

  const _GlassSummaryCard({
    required this.title,
    required this.amount,
    required this.gradientColors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withValues(alpha: isDark ? 0.3 : 0.15),
                gradientColors[1].withValues(alpha: isDark ? 0.15 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: gradientColors[0].withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: gradientColors[0].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: gradientColors[0], size: 20),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      color: gradientColors[0].withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                CurrencyUtils.format(amount),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassBalanceCard extends StatelessWidget {
  final double amount;
  final bool isPositive;

  const _GlassBalanceCard({
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isPositive ? const Color(0xFF00C853) : const Color(0xFFFF1744);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                CurrencyUtils.format(amount.abs()),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

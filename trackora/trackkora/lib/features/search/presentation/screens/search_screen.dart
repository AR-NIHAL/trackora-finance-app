import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:trackkora/core/utils/currency_utils.dart';
import 'package:trackkora/core/utils/date_utils.dart' as app_date;

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  TransactionType? _typeFilter;
  DateTime? _dateStart;
  DateTime? _dateEnd;
  String? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _typeFilter == null,
                      onSelected: (_) => setState(() => _typeFilter = null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Income'),
                      selected: _typeFilter == TransactionType.income,
                      onSelected: (selected) => setState(
                        () => _typeFilter = selected ? TransactionType.income : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Expense'),
                      selected: _typeFilter == TransactionType.expense,
                      onSelected: (selected) => setState(
                        () => _typeFilter = selected ? TransactionType.expense : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDateRange,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _dateStart != null && _dateEnd != null
                              ? '${_dateStart!.day}/${_dateStart!.month} - ${_dateEnd!.day}/${_dateEnd!.month}'
                              : 'Date Range',
                        ),
                      ),
                    ),
                    if (_dateStart != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => setState(() {
                          _dateStart = null;
                          _dateEnd = null;
                        }),
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                categoriesAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                  data: (categories) => DropdownButtonFormField<String>(
                    initialValue: _categoryFilter,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...categories.map((c) => DropdownMenuItem(
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
                          )),
                    ],
                    onChanged: (value) =>
                        setState(() => _categoryFilter = value),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (transactions) {
                final filtered = _filterTransactions(transactions);
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No matching transactions',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return categoriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (categories) {
                    final categoryMap = {for (final c in categories) c.id: c};
                    return _SearchResults(
                      transactions: filtered,
                      categoryMap: categoryMap,
                      ref: ref,
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

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    final query = _searchController.text.toLowerCase().trim();

    return transactions.where((t) {
      if (query.isNotEmpty) {
        final matchesTitle = t.title.toLowerCase().contains(query);
        final matchesNotes = t.notes?.toLowerCase().contains(query) ?? false;
        if (!matchesTitle && !matchesNotes) return false;
      }
      if (_typeFilter != null && t.type != _typeFilter) return false;
      if (_categoryFilter != null && t.categoryId != _categoryFilter) return false;
      if (_dateStart != null && _dateEnd != null) {
        final start = DateTime(_dateStart!.year, _dateStart!.month, _dateStart!.day);
        final end = DateTime(_dateEnd!.year, _dateEnd!.month, _dateEnd!.day, 23, 59, 59);
        if (t.date.isBefore(start) || t.date.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateStart != null && _dateEnd != null
          ? DateTimeRange(start: _dateStart!, end: _dateEnd!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _dateStart = picked.start;
        _dateEnd = picked.end;
      });
    }
  }
}

class _SearchResults extends StatelessWidget {
  final List<Transaction> transactions;
  final Map<String, dynamic> categoryMap;
  final WidgetRef ref;

  const _SearchResults({
    required this.transactions,
    required this.categoryMap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        final category = categoryMap[t.categoryId];
        final isIncome = t.type == TransactionType.income;
        final color = isIncome ? Colors.green : Colors.red;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: category != null
                ? Color(category.colorValue).withValues(alpha: 0.2)
                : Colors.grey.shade200,
            child: category != null
                ? Icon(
                    IconData(category.iconCodePoint,
                        fontFamily: 'MaterialIcons'),
                    color: Color(category.colorValue),
                    size: 20,
                  )
                : const Icon(Icons.category, size: 20),
          ),
          title: Text(
            t.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(category?.name ?? 'Unknown'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.formatWithSign(t.amount, isIncome: isIncome),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 15,
                ),
              ),
              Text(
                app_date.DateUtils.formatDate(t.date),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          onTap: () => context.push('/edit-transaction/${t.id}'),
        );
      },
    );
  }
}

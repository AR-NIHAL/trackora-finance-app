import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/models/transaction_model.dart';
import 'transaction_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedTypeProvider = StateProvider<String>((ref) => 'all');
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

final filteredTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedType = ref.watch(selectedTypeProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return transactions.where((tx) {
    final matchesSearch =
        tx.title.toLowerCase().contains(searchQuery) ||
        tx.category.toLowerCase().contains(searchQuery) ||
        (tx.note?.toLowerCase().contains(searchQuery) ?? false);

    final matchesType = selectedType == 'all' ? true : tx.type == selectedType;

    final matchesCategory = selectedCategory == 'all'
        ? true
        : tx.category == selectedCategory;

    return matchesSearch && matchesType && matchesCategory;
  }).toList();
});

final availableCategoriesProvider = Provider<List<String>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;

  final categories = transactions.map((tx) => tx.category).toSet().toList()
    ..sort();

  return ['all', ...categories];
});

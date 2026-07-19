import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trackora/core/theme/app_spacing.dart';
import 'package:trackora/core/utils/id_generator.dart';
import 'package:trackora/features/categories/domain/entities/category.dart';
import 'package:trackora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackora/features/transactions/domain/entities/transaction.dart';
import 'package:trackora/features/transactions/presentation/providers/transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md.toDouble()),
          children: [
            Text('Type', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm.toDouble()),
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selected) {
                setState(() {
                  _type = selected.first;
                  _selectedCategoryId = null;
                });
              },
            ),
            SizedBox(height: AppSpacing.lg.toDouble()),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.toDouble()),
            Text('Category', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm.toDouble()),
            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (categories) {
                final filtered = categories
                    .where((c) =>
                        c.type ==
                        (_type == TransactionType.income
                            ? CategoryType.income
                            : CategoryType.expense))
                    .toList();

                if (filtered.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md.toDouble()),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Theme.of(context).colorScheme.error),
                          SizedBox(width: AppSpacing.sm.toDouble()),
                          Expanded(
                            child: Text(
                              'No ${_type == TransactionType.income ? 'income' : 'expense'} categories yet. Create one in Settings > Categories first.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final validIds = filtered.map((c) => c.id).toList();
                final currentId = validIds.contains(_selectedCategoryId)
                    ? _selectedCategoryId
                    : null;

                return DropdownButtonFormField<String>(
                  key: ValueKey('cat_${_type.name}_$currentId'),
                  initialValue: currentId,
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                  ),
                  items: filtered
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                  validator: (value) {
                    if (value == null) return 'Please select a category';
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: AppSpacing.lg.toDouble()),
            Text('Date', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm.toDouble()),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Transaction Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMd().format(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg.toDouble()),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'e.g. Weekly groceries',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final transaction = Transaction(
      id: generateId(),
      amount: double.parse(_amountController.text.trim()),
      type: _type,
      categoryId: _selectedCategoryId!,
      date: _selectedDate,
      note: _noteController.text.trim(),
    );

    ref.read(transactionListProvider.notifier).add(transaction);
    Navigator.of(context).pop();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;
  const AddTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.transactionId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadTransaction();
    }
  }

  Future<void> _loadTransaction() async {
    final transactions = ref.read(transactionsProvider).valueOrNull ?? [];
    final transaction = transactions.firstWhere(
      (t) => t.id == widget.transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );
    setState(() {
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toString();
      _notesController.text = transaction.notes ?? '';
      _type = transaction.type;
      _selectedCategoryId = transaction.categoryId;
      _selectedDate = transaction.date;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type Toggle
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Expense'),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  icon: Icon(Icons.arrow_upward),
                  label: Text('Income'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selected) => setState(() => _type = selected.first),
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (categories) => DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Row(
                      children: [
                        Icon(
                          IconData(c.iconCodePoint, fontFamily: 'MaterialIcons'),
                          color: Color(c.colorValue),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(c.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategoryId = value),
                validator: (value) {
                  if (value == null) return 'Please select a category';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save Button
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(isEditing ? Icons.check : Icons.add),
              label: Text(isEditing ? 'Update' : 'Add Transaction'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final transaction = Transaction(
      id: isEditing ? widget.transactionId! : const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      type: _type,
      categoryId: _selectedCategoryId!,
      date: _selectedDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    final actions = ref.read(transactionActionsProvider);
    if (isEditing) {
      await actions.update(transaction);
    } else {
      await actions.add(transaction);
    }

    if (mounted) context.pop();
  }
}

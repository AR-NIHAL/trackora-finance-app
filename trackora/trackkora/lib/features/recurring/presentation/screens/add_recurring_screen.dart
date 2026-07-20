import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/recurring/presentation/providers/recurring_providers.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';

class AddRecurringScreen extends ConsumerStatefulWidget {
  final String? recurringId;
  const AddRecurringScreen({super.key, this.recurringId});

  @override
  ConsumerState<AddRecurringScreen> createState() => _AddRecurringScreenState();
}

class _AddRecurringScreenState extends ConsumerState<AddRecurringScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  RecurringFrequency _frequency = RecurringFrequency.monthly;
  String? _selectedCategoryId;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  bool get isEditing => widget.recurringId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadRecurring();
    }
  }

  Future<void> _loadRecurring() async {
    final recurring = ref.read(recurringTransactionsProvider).valueOrNull ?? [];
    final item = recurring.firstWhere(
      (r) => r.id == widget.recurringId,
      orElse: () => throw Exception('Recurring transaction not found'),
    );
    setState(() {
      _titleController.text = item.title;
      _amountController.text = item.amount.toString();
      _notesController.text = item.notes ?? '';
      _type = item.type;
      _frequency = item.frequency;
      _selectedCategoryId = item.categoryId;
      _startDate = item.startDate;
      _endDate = item.endDate;
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
        title: Text(isEditing ? 'Edit Recurring' : 'Add Recurring'),
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

            // Frequency
            DropdownButtonFormField<RecurringFrequency>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                prefixIcon: Icon(Icons.repeat),
              ),
              items: const [
                DropdownMenuItem(value: RecurringFrequency.daily, child: Text('Daily')),
                DropdownMenuItem(value: RecurringFrequency.weekly, child: Text('Weekly')),
                DropdownMenuItem(value: RecurringFrequency.monthly, child: Text('Monthly')),
                DropdownMenuItem(value: RecurringFrequency.yearly, child: Text('Yearly')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _frequency = value);
              },
            ),
            const SizedBox(height: 16),

            // Start Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Start Date'),
              subtitle: Text(
                '${_startDate.day}/${_startDate.month}/${_startDate.year}',
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
            ),
            const SizedBox(height: 8),

            // End Date (optional)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('End Date (optional)'),
              subtitle: Text(
                _endDate != null
                    ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                    : 'No end date',
              ),
              trailing: _endDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _endDate = null),
                    )
                  : null,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
                  firstDate: _startDate,
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _endDate = picked);
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
              label: Text(isEditing ? 'Update' : 'Add Recurring'),
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

    final recurring = RecurringTransaction(
      id: isEditing ? widget.recurringId! : const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      type: _type,
      categoryId: _selectedCategoryId!,
      frequency: _frequency,
      startDate: _startDate,
      endDate: _endDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    final actions = ref.read(recurringActionsProvider);
    if (isEditing) {
      await actions.update(recurring);
    } else {
      await actions.add(recurring);
    }

    if (mounted) context.pop();
  }
}

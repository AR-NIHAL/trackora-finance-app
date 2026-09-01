import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/add_transaction/presentation/widgets/transaction_type_selector.dart';
import 'package:expense_tracker/features/add_transaction/presentation/widgets/transaction_text_field.dart';
import 'package:expense_tracker/features/add_transaction/presentation/widgets/transaction_dropdown_field.dart';
import 'package:expense_tracker/features/add_transaction/presentation/widgets/transaction_date_field.dart';
import 'package:expense_tracker/features/add_transaction/presentation/widgets/save_transaction_button.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/category_model.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _isRecurring = false;

  List<CategoryModel> get _categories {
    return _type == TransactionType.expense
        ? DummyCategories.expenseCategories
        : DummyCategories.incomeCategories;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      _categoryId = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final transaction = TransactionModel(
      id: AppUtils.generateId(),
      title: title,
      amount: amount,
      type: _type,
      categoryId: _categoryId!,
      date: _date,
      note: _noteController.text.trim(),
      isRecurring: _isRecurring,
    );

    ref.read(transactionProvider.notifier).addTransaction(transaction);

    _formKey.currentState!.reset();
    _titleController.clear();
    _amountController.clear();
    _noteController.clear();
    setState(() {
      _categoryId = null;
      _date = DateTime.now();
      _type = TransactionType.expense;
      _isRecurring = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Transaction',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            TransactionTypeSelector(
              selectedType: _type,
              onChanged: _onTypeChanged,
            ),
            const SizedBox(height: 16),

            TransactionTextField(
              label: 'Title',
              hintText: 'Enter transaction title',
              textInputAction: TextInputAction.next,
              controller: _titleController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TransactionTextField(
              label: 'Amount',
              hintText: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              prefixText: '\$ ',
              controller: _amountController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TransactionDropdownField(
              label: 'Category',
              hintText: 'Select category',
              value: _categoryId,
              items: _categories,
              onChanged: (value) {
                setState(() => _categoryId = value);
              },
            ),
            const SizedBox(height: 16),

            TransactionDateField(label: 'Date', value: _date, onTap: _pickDate),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: SwitchListTile(
                value: _isRecurring,
                onChanged: (value) => setState(() => _isRecurring = value),
                title: Text(
                  'Recurring',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'This transaction repeats (e.g. rent, salary, subscription)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),

            TransactionTextField(
              label: 'Note',
              hintText: 'Add a note (optional)',
              maxLines: 4,
              textInputAction: TextInputAction.done,
              controller: _noteController,
            ),
            const SizedBox(height: 24),

            SaveTransactionButton(onPressed: _saveTransaction),
          ],
        ),
      ),
    );
  }
}

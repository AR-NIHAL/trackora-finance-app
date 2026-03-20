import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import 'amount_field.dart';
import 'category_dropdown.dart';
import 'transaction_type_selector.dart';

class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({super.key});

  @override
  ConsumerState<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  String _selectedType = 'expense';
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // void _saveTransaction() {
  //   final isValid = _formKey.currentState?.validate() ?? false;

  //   if (!isValid) return;

  //   final amount = double.parse(_amountController.text.trim());

  //   final transaction = TransactionModel(
  //     id: DateTime.now().microsecondsSinceEpoch.toString(),
  //     title: _titleController.text.trim(),
  //     amount: amount,
  //     type: _selectedType,
  //     category: _selectedCategory!,
  //     date: _selectedDate,
  //     note: _noteController.text.trim().isEmpty
  //         ? null
  //         : _noteController.text.trim(),
  //   );

  //   ref.read(transactionProvider.notifier).addTransaction(transaction);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Transaction added successfully')),
  //   );

  //   _titleController.clear();
  //   _amountController.clear();
  //   _noteController.clear();

  //   setState(() {
  //     _selectedType = 'expense';
  //     _selectedCategory = null;
  //     _selectedDate = DateTime.now();
  //   });
  // }
  Future<void> _saveTransaction() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    final amount = double.parse(_amountController.text.trim());

    final transaction = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: amount,
      type: _selectedType,
      category: _selectedCategory!,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    await ref.read(transactionProvider.notifier).addTransaction(transaction);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction added successfully')),
    );

    _titleController.clear();
    _amountController.clear();
    _noteController.clear();

    setState(() {
      _selectedType = 'expense';
      _selectedCategory = null;
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransactionTypeSelector(
            selectedType: _selectedType,
            onChanged: (value) {
              setState(() {
                _selectedType = value;
                _selectedCategory = null;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter transaction title',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AmountField(controller: _amountController),
          const SizedBox(height: 16),
          CategoryDropdown(
            selectedType: _selectedType,
            selectedCategory: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Date',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined),
                  const SizedBox(width: 12),
                  Text(_formatDate(_selectedDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteController,
            minLines: 3,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Note (optional)',
              hintText: 'Write a short note',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveTransaction,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Transaction'),
            ),
          ),
        ],
      ),
    );
  }
}

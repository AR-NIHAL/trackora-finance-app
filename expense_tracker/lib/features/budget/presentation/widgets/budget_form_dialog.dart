import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:flutter/material.dart';

class BudgetFormDialog extends StatefulWidget {
  final BudgetModel? existingBudget;

  const BudgetFormDialog({super.key, this.existingBudget});

  @override
  State<BudgetFormDialog> createState() => _BudgetFormDialogState();
}

class _BudgetFormDialogState extends State<BudgetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  String? _categoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.existingBudget?.limitAmount == 0
          ? ''
          : widget.existingBudget?.limitAmount.toStringAsFixed(0),
    );
    _categoryId = widget.existingBudget?.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingBudget == null ? 'Set Category Budget' : 'Edit Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: DummyCategories.expenseCategories
                  .map(
                    (category) => DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monthly limit',
                prefixText: '\$ ',
              ),
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final amount = double.parse(_amountController.text.trim());
            final now = DateTime.now();
            final id = '${_categoryId}_${now.year}_${now.month}';
            final budget = BudgetModel(
              id: id,
              categoryId: _categoryId!,
              limitAmount: amount,
              month: DateTime(now.year, now.month),
            );
            Navigator.of(context).pop(budget);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

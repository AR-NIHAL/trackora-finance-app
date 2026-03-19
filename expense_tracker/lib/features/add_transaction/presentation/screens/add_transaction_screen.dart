import 'package:flutter/material.dart';
import '../widgets/transaction_type_selector.dart';
import '../widgets/transaction_text_field.dart';
import '../widgets/transaction_dropdown_field.dart';
import '../widgets/transaction_date_field.dart';
import '../widgets/save_transaction_button.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const expenseCategories = [
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Health',
      'Entertainment',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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

          const TransactionTypeSelector(),
          const SizedBox(height: 16),

          const TransactionTextField(
            label: 'Title',
            hintText: 'Enter transaction title',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          const TransactionTextField(
            label: 'Amount',
            hintText: 'Enter amount',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            prefixText: '\$ ',
          ),
          const SizedBox(height: 16),

          TransactionDropdownField(
            label: 'Category',
            hintText: 'Select category',
            value: null,
            items: expenseCategories,
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),

          const TransactionDateField(label: 'Date', value: '19 Mar 2026'),
          const SizedBox(height: 16),

          const TransactionTextField(
            label: 'Note',
            hintText: 'Add a note (optional)',
            maxLines: 4,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),

          const SaveTransactionButton(),
        ],
      ),
    );
  }
}

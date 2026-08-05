import 'package:flutter/material.dart';

class ContributeDialog extends StatefulWidget {
  final String goalName;
  final bool isWithdraw;

  const ContributeDialog({
    super.key,
    required this.goalName,
    this.isWithdraw = false,
  });

  @override
  State<ContributeDialog> createState() => _ContributeDialogState();
}

class _ContributeDialogState extends State<ContributeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verb = widget.isWithdraw ? 'Withdraw' : 'Contribute';

    return AlertDialog(
      title: Text('$verb to ${widget.goalName}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
          validator: (value) {
            final parsed = double.tryParse((value ?? '').trim());
            if (parsed == null || parsed <= 0) {
              return 'Enter a valid amount';
            }
            return null;
          },
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
            Navigator.of(
              context,
            ).pop(double.parse(_amountController.text.trim()));
          },
          child: Text(verb),
        ),
      ],
    );
  }
}

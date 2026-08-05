import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:flutter/material.dart';

class GoalFormDialog extends StatefulWidget {
  final SavingGoal? existingGoal;

  const GoalFormDialog({super.key, this.existingGoal});

  @override
  State<GoalFormDialog> createState() => _GoalFormDialogState();
}

class _GoalFormDialogState extends State<GoalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingGoal?.name);
    _targetController = TextEditingController(
      text: widget.existingGoal?.targetAmount.toStringAsFixed(0),
    );
    _deadline = widget.existingGoal?.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingGoal == null ? 'New Goal' : 'Edit Goal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Goal name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a goal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Target amount',
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
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _deadline ?? DateTime.now().add(
                    const Duration(days: 90),
                  ),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _deadline = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Deadline (optional)',
                ),
                child: Text(
                  _deadline == null
                      ? 'No deadline'
                      : AppUtils.formatFullDate(_deadline!),
                ),
              ),
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
            final goal = SavingGoal(
              id: widget.existingGoal?.id ?? AppUtils.generateId(),
              name: _nameController.text.trim(),
              targetAmount: double.parse(_targetController.text.trim()),
              savedAmount: widget.existingGoal?.savedAmount ?? 0,
              deadline: _deadline,
            );
            Navigator.of(context).pop(goal);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

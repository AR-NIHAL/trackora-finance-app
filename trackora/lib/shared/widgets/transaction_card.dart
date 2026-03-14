import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackora/features/add_transaction/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel item;
  final VoidCallback? onLongPress;

  const TransactionCard({super.key, required this.item, this.onLongPress});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_bus;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
        return Icons.receipt_long;
      case 'Health':
        return Icons.health_and_safety;
      case 'Salary':
        return Icons.attach_money;
      case 'Freelance':
        return Icons.work;
      case 'Bonus':
        return Icons.emoji_events;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = item.type == 'Expense';

    return Card(
      child: ListTile(
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? Colors.red.shade100
              : Colors.green.shade100,
          child: Icon(
            _getCategoryIcon(item.category),
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
        title: Text(item.category),
        subtitle: Text(item.note.isEmpty ? 'No note' : item.note),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isExpense ? '-' : '+'} ৳${item.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isExpense ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy').format(item.date),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

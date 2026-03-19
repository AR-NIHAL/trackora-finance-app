import 'package:flutter/material.dart';

class CurrencyTile extends StatelessWidget {
  const CurrencyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withValues(alpha: 0.12),
        child: const Icon(Icons.currency_exchange, color: Colors.blue),
      ),
      title: const Text(
        'Currency',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Bangladeshi Taka (৳)'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Currency selection will be added later'),
          ),
        );
      },
    );
  }
}

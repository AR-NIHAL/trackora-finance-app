import 'package:flutter/material.dart';
import 'recent_transaction_card.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const transactions = [
      {
        'title': 'Starbucks Coffee',
        'category': 'Food & Drinks',
        'amount': '-\$12.50',
        'date': 'Today',
        'icon': Icons.local_cafe_outlined,
      },
      {
        'title': 'Monthly Salary',
        'category': 'Income',
        'amount': '+\$2,800.00',
        'date': '18 Mar',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': 'Uber Ride',
        'category': 'Transport',
        'amount': '-\$18.20',
        'date': '17 Mar',
        'icon': Icons.directions_car_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecentTransactionCard(
              title: item['title']! as String,
              category: item['category']! as String,
              amount: item['amount']! as String,
              date: item['date']! as String,
              icon: item['icon']! as IconData,
            ),
          ),
        ),
      ],
    );
  }
}

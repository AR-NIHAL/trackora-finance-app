import 'package:flutter/material.dart';
import '../../../../shared/widgets/primary_card.dart';
import '../../../../shared/widgets/section_title.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Recent Transactions'),
        SizedBox(height: 12),
        PrimaryCard(child: Text('Recent transaction list will appear here')),
      ],
    );
  }
}

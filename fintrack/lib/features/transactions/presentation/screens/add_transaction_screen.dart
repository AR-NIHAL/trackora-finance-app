import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../widgets/transaction_form.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: SingleChildScrollView(child: TransactionForm()),
    );
  }
}

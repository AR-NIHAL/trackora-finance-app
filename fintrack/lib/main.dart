import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/services/local_storage_service.dart';
import 'features/budget/data/models/budget_model.dart';
import 'features/transactions/data/models/transaction_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  await Hive.openBox<TransactionModel>(LocalStorageService.transactionBoxName);

  await Hive.openBox<BudgetModel>(LocalStorageService.budgetBoxName);

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}

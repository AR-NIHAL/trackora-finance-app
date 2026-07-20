import 'package:hive_ce/hive.dart';
import 'package:trackkora/features/transactions/data/models/transaction_model.dart';
import 'package:trackkora/features/categories/data/models/category_model.dart';
import 'package:trackkora/features/recurring/data/models/recurring_transaction_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<TransactionModel>(),
  AdapterSpec<CategoryModel>(),
  AdapterSpec<RecurringTransactionModel>(),
])
class HiveAdapters {}

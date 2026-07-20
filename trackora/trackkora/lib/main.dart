import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:trackkora/app.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/core/hive/hive_registrar.g.dart';
import 'package:trackkora/features/categories/data/models/category_model.dart';
import 'package:trackkora/features/recurring/data/models/recurring_transaction_model.dart';
import 'package:trackkora/features/transactions/data/models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox<String>(HiveBoxes.settings);
  await Hive.openBox<TransactionModel>(HiveBoxes.transactions);
  await Hive.openBox<CategoryModel>(HiveBoxes.categories);
  await Hive.openBox<RecurringTransactionModel>(HiveBoxes.recurring);

  runApp(
    const ProviderScope(
      child: TrackKoraApp(),
    ),
  );
}

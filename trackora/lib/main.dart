import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:trackora/app.dart';
import 'package:trackora/core/constants/app_constants.dart';
import 'package:trackora/features/categories/data/models/category_model.dart';
import 'package:trackora/features/transactions/data/models/transaction_model.dart';
import 'package:trackora/hive_registrar.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<CategoryModel>(AppConstants.categoriesBox);
  await Hive.openBox<TransactionModel>(AppConstants.transactionsBox);

  runApp(
    const ProviderScope(
      child: TrackoraApp(),
    ),
  );
}

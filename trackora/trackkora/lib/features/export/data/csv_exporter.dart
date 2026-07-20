import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';
import 'package:trackkora/core/utils/date_utils.dart' as app_date;

class CsvExporter {
  static Future<String> export({
    required List<Transaction> transactions,
    required Map<String, Category> categoryMap,
  }) async {
    final rows = <List<String>>[
      ['Date', 'Title', 'Type', 'Category', 'Amount', 'Notes'],
    ];

    for (final t in transactions) {
      final category = categoryMap[t.categoryId];
      rows.add([
        app_date.DateUtils.formatDate(t.date),
        t.title,
        t.type == TransactionType.income ? 'Income' : 'Expense',
        category?.name ?? 'Unknown',
        t.amount.toStringAsFixed(2),
        t.notes ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/trackkora_export_$timestamp.csv');
    await file.writeAsString(csv);
    return file.path;
  }
}

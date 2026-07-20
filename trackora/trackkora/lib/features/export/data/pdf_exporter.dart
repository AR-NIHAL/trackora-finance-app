import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';
import 'package:trackkora/core/utils/currency_utils.dart';
import 'package:trackkora/core/utils/date_utils.dart' as app_date;

class PdfExporter {
  static Future<String> export({
    required List<Transaction> transactions,
    required Map<String, Category> categoryMap,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('          TrackKora Transaction Report');
    buffer.writeln('========================================');
    buffer.writeln();

    if (startDate != null && endDate != null) {
      buffer.writeln('Period: ${app_date.DateUtils.formatDate(startDate)} - ${app_date.DateUtils.formatDate(endDate)}');
    } else {
      buffer.writeln('Period: All Transactions');
    }

    buffer.writeln('Generated: ${app_date.DateUtils.formatDate(DateTime.now())}');
    buffer.writeln();

    double totalIncome = 0;
    double totalExpense = 0;

    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }

    buffer.writeln('----------------------------------------');
    buffer.writeln('SUMMARY');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Total Income:    ${CurrencyUtils.format(totalIncome)}');
    buffer.writeln('Total Expenses:  ${CurrencyUtils.format(totalExpense)}');
    buffer.writeln('Net Balance:     ${CurrencyUtils.format(totalIncome - totalExpense)}');
    buffer.writeln('Transactions:    ${transactions.length}');
    buffer.writeln();

    buffer.writeln('----------------------------------------');
    buffer.writeln('TRANSACTIONS');
    buffer.writeln('----------------------------------------');
    buffer.writeln();

    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final t in sorted) {
      final category = categoryMap[t.categoryId];
      final type = t.type == TransactionType.income ? 'INCOME' : 'EXPENSE';
      final sign = t.type == TransactionType.income ? '+' : '-';

      buffer.writeln('${app_date.DateUtils.formatDate(t.date)}  [$type]');
      buffer.writeln('  ${t.title}');
      buffer.writeln('  Amount: $sign${CurrencyUtils.format(t.amount)}');
      buffer.writeln('  Category: ${category?.name ?? "Unknown"}');
      if (t.notes != null && t.notes!.isNotEmpty) {
        buffer.writeln('  Notes: ${t.notes}');
      }
      buffer.writeln();
    }

    buffer.writeln('========================================');
    buffer.writeln('            End of Report');
    buffer.writeln('========================================');

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/trackkora_report_$timestamp.txt');
    await file.writeAsString(buffer.toString());
    return file.path;
  }
}

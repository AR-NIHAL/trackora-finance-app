import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/export/data/csv_exporter.dart';
import 'package:trackkora/features/export/data/pdf_exporter.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';

enum ExportFormat { csv, pdf }

class ExportActions {
  final Ref _ref;

  ExportActions(this._ref);

  Future<String> exportToCsv({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repo = _ref.read(transactionRepositoryProvider);
    final transactions = startDate != null && endDate != null
        ? await repo.getByDateRange(startDate, endDate)
        : await repo.getAll();

    final categories = await _ref.read(categoriesProvider.future);
    final categoryMap = {for (final c in categories) c.id: c};

    return CsvExporter.export(
      transactions: transactions,
      categoryMap: categoryMap,
    );
  }

  Future<String> exportToPdf({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repo = _ref.read(transactionRepositoryProvider);
    final transactions = startDate != null && endDate != null
        ? await repo.getByDateRange(startDate, endDate)
        : await repo.getAll();

    final categories = await _ref.read(categoriesProvider.future);
    final categoryMap = {for (final c in categories) c.id: c};

    return PdfExporter.export(
      transactions: transactions,
      categoryMap: categoryMap,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

final exportActionsProvider = Provider<ExportActions>((ref) {
  return ExportActions(ref);
});

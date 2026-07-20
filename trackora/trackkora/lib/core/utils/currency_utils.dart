import 'package:intl/intl.dart';

abstract final class CurrencyUtils {
  static final _formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactFormatter = NumberFormat.compactCurrency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 1,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactFormatter.format(amount);
  }

  static String formatWithSign(double amount, {bool isIncome = true}) {
    final prefix = isIncome ? '+' : '-';
    return '$prefix${_formatter.format(amount.abs())}';
  }
}

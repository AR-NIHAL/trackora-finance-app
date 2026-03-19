import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'transaction_notifier.dart';
import 'transaction_state.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
      return TransactionNotifier();
    });

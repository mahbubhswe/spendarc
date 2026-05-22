import 'package:equatable/equatable.dart';

import '../../../core/failure.dart';
import '../data/transaction_model.dart';

enum TransactionFilter { all, income, expense }

class TransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final TransactionFilter filter;
  final Failure? failure;

  const TransactionState({
    required this.transactions,
    required this.filter,
    required this.failure,
  });

  factory TransactionState.initial() {
    return const TransactionState(
      transactions: [],
      filter: TransactionFilter.all,
      failure: null,
    );
  }

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    TransactionFilter? filter,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  List<TransactionModel> get filteredTransactions {
    switch (filter) {
      case TransactionFilter.income:
        return transactions.where((item) => !item.isExpense).toList();
      case TransactionFilter.expense:
        return transactions.where((item) => item.isExpense).toList();
      case TransactionFilter.all:
        return transactions;
    }
  }

  @override
  List<Object?> get props => [transactions, filter, failure];
}

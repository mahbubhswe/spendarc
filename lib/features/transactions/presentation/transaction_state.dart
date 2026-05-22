import 'package:equatable/equatable.dart';

import '../data/transaction_model.dart';

enum TransactionFilter { all, income, expense }

class TransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final TransactionFilter filter;
  final String? errorMessage;

  const TransactionState({
    required this.transactions,
    required this.filter,
    required this.errorMessage,
  });

  factory TransactionState.initial() {
    return const TransactionState(
      transactions: [],
      filter: TransactionFilter.all,
      errorMessage: null,
    );
  }

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    TransactionFilter? filter,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
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
  List<Object?> get props => [transactions, filter, errorMessage];
}

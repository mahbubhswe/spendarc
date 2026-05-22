import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/transaction_model.dart';
import '../domain/transaction_usecases.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final GetTransactions getTransactionsUseCase;

  final AddTransaction addTransactionUseCase;

  final DeleteTransaction deleteTransactionUseCase;

  TransactionCubit(
    this.getTransactionsUseCase,
    this.addTransactionUseCase,
    this.deleteTransactionUseCase,
  ) : super(TransactionState.initial());

  double get totalIncome {
    return state.transactions
        .where((e) => !e.isExpense)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalExpense {
    return state.transactions
        .where((e) => e.isExpense)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  void loadTransactions() {
    final items = List<TransactionModel>.of(getTransactionsUseCase());

    emit(state.copyWith(transactions: items));
  }

  void setFilter(TransactionFilter filter) {
    if (state.filter == filter) {
      return;
    }

    emit(state.copyWith(filter: filter));
  }

  bool addTransaction(String title, double amount, bool isExpense) {
    if (isExpense && amount > totalBalance) {
      emit(
        state.copyWith(
          errorMessage: 'Expense cannot be greater than current balance',
        ),
      );
      return false;
    }

    final transaction = TransactionModel(
      title: title,
      amount: amount,
      isExpense: isExpense,
      isSynced: false,
      syncStatus: TransactionModel.pendingStatus,
    );

    addTransactionUseCase(transaction);

    loadTransactions();
    emit(state.copyWith(clearErrorMessage: true));
    return true;
  }

  void deleteTransaction(int id) {
    deleteTransactionUseCase(id);

    loadTransactions();
  }

  void restoreTransaction(TransactionModel transaction) {
    addTransactionUseCase(transaction);

    loadTransactions();
  }

  void clearErrorMessage() {
    if (state.errorMessage == null) {
      return;
    }

    emit(state.copyWith(clearErrorMessage: true));
  }
}

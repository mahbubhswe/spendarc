import '../data/transaction_model.dart';

abstract class TransactionRepository {
  List<TransactionModel> getTransactions();
  List<TransactionModel> getPendingTransactions();

  void addTransaction(TransactionModel model);
  void updateTransaction(TransactionModel model);

  void deleteTransaction(int id);
}

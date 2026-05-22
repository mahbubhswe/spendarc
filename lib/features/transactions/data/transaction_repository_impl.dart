import '../domain/transaction_repository.dart';
import 'transaction_local_source.dart';
import 'transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalSource localSource;

  TransactionRepositoryImpl(this.localSource);

  @override
  List<TransactionModel> getTransactions() {
    return localSource.getTransactions();
  }

  @override
  List<TransactionModel> getPendingTransactions() {
    return localSource.getPendingTransactions();
  }

  @override
  void addTransaction(TransactionModel model) {
    localSource.addTransaction(model);
  }

  @override
  void updateTransaction(TransactionModel model) {
    localSource.updateTransaction(model);
  }

  @override
  void deleteTransaction(int id) {
    localSource.deleteTransaction(id);
  }
}

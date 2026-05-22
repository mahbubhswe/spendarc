import '../data/transaction_model.dart';
import 'transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  List<TransactionModel> call() {
    return repository.getTransactions();
  }
}

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  void call(TransactionModel model) {
    repository.addTransaction(model);
  }
}

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  void call(int id) {
    repository.deleteTransaction(id);
  }
}

class GetPendingTransactions {
  final TransactionRepository repository;

  GetPendingTransactions(this.repository);

  List<TransactionModel> call() {
    return repository.getPendingTransactions();
  }
}

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  void call(TransactionModel model) {
    repository.updateTransaction(model);
  }
}

import '../../../objectbox.g.dart';
import '../../../core/objectbox_service.dart';
import 'transaction_model.dart';

class TransactionLocalSource {
  final ObjectBoxService objectBox;

  TransactionLocalSource(this.objectBox);

  List<TransactionModel> getTransactions() {
    return objectBox.transactionBox.getAll();
  }

  List<TransactionModel> getPendingTransactions() {
    final query = objectBox.transactionBox
        .query(
          TransactionModel_.syncStatus.equals(TransactionModel.pendingStatus),
        )
        .build();

    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  void addTransaction(TransactionModel model) {
    objectBox.transactionBox.put(model);
  }

  void updateTransaction(TransactionModel model) {
    objectBox.transactionBox.put(model);
  }

  void deleteTransaction(int id) {
    objectBox.transactionBox.remove(id);
  }
}

import 'package:path_provider/path_provider.dart';

import '../../objectbox.g.dart';
import '../../features/transactions/data/transaction_model.dart';

class ObjectBoxService {
  late final Store store;

  late final Box<TransactionModel> transactionBox;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    store = await openStore(directory: '${dir.path}/spendarc-db');

    transactionBox = store.box<TransactionModel>();
  }
}

import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  static const String pendingStatus = 'pending';
  static const String syncedStatus = 'synced';
  static const String failedStatus = 'failed';

  int id;

  String title;
  double amount;
  bool isExpense;
  bool isSynced;
  String syncStatus;

  TransactionModel({
    this.id = 0,
    required this.title,
    required this.amount,
    required this.isExpense,
    this.isSynced = false,
    this.syncStatus = pendingStatus,
  });
}

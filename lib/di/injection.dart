import 'package:get_it/get_it.dart';

import '../core/database/objectbox_service.dart';
import '../features/transactions/data/transaction_local_source.dart';
import '../features/transactions/data/transaction_repository_impl.dart';
import '../features/transactions/domain/transaction_repository.dart';
import '../features/transactions/domain/transaction_usecases.dart';
import '../features/transactions/presentation/sync_cubit.dart';
import '../features/transactions/presentation/transaction_cubit.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final objectBox = ObjectBoxService();

  await objectBox.init();

  sl.registerLazySingleton(() => objectBox);

  sl.registerLazySingleton(() => TransactionLocalSource(sl()));

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetTransactions(sl()));

  sl.registerLazySingleton(() => AddTransaction(sl()));

  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  sl.registerLazySingleton(() => GetPendingTransactions(sl()));

  sl.registerLazySingleton(() => UpdateTransaction(sl()));

  sl.registerFactory(() => TransactionCubit(sl(), sl(), sl()));

  sl.registerFactory(() => SyncCubit(sl(), sl()));
}

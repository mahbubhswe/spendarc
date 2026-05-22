import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/transaction_model.dart';
import '../domain/transaction_usecases.dart';

enum SyncStatus { idle, syncing, synced, offline, failed }

class SyncState extends Equatable {
  final SyncStatus status;
  final String? message;
  final int pendingCount;

  const SyncState({
    required this.status,
    required this.message,
    required this.pendingCount,
  });

  factory SyncState.initial() {
    return const SyncState(
      status: SyncStatus.idle,
      message: null,
      pendingCount: 0,
    );
  }

  bool get isSyncing => status == SyncStatus.syncing;
  bool get hasMessage => message != null && message!.isNotEmpty;

  SyncState copyWith({
    SyncStatus? status,
    String? message,
    int? pendingCount,
    bool clearMessage = false,
  }) {
    return SyncState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  @override
  List<Object?> get props => [status, message, pendingCount];
}

class SyncCubit extends Cubit<SyncState> {
  final GetPendingTransactions getPendingTransactionsUseCase;
  final UpdateTransaction updateTransactionUseCase;

  SyncCubit(this.getPendingTransactionsUseCase, this.updateTransactionUseCase)
    : super(SyncState.initial());

  Future<void> syncPendingTransactions() async {
    if (state.isSyncing) {
      return;
    }

    final pendingItems = List<TransactionModel>.of(
      getPendingTransactionsUseCase(),
    );

    if (pendingItems.isEmpty) {
      emit(
        state.copyWith(
          status: SyncStatus.idle,
          pendingCount: 0,
          clearMessage: true,
        ),
      );
      return;
    }

    final hasNetwork = await _hasInternetConnection();

    if (!hasNetwork) {
      emit(
        state.copyWith(
          status: SyncStatus.offline,
          pendingCount: pendingItems.length,
          message: 'Offline • ${pendingItems.length} pending',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SyncStatus.syncing,
        pendingCount: pendingItems.length,
        message: 'Syncing...',
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      for (final item in pendingItems) {
        item.isSynced = true;
        item.syncStatus = TransactionModel.syncedStatus;
        updateTransactionUseCase(item);
      }

      emit(
        state.copyWith(
          status: SyncStatus.synced,
          pendingCount: 0,
          message: 'Synced',
        ),
      );

      await Future<void>.delayed(const Duration(seconds: 2));

      if (isClosed || state.status != SyncStatus.synced) {
        return;
      }

      emit(
        state.copyWith(
          status: SyncStatus.idle,
          clearMessage: true,
          pendingCount: 0,
        ),
      );
    } catch (_) {
      for (final item in pendingItems) {
        item.isSynced = false;
        item.syncStatus = TransactionModel.failedStatus;
        updateTransactionUseCase(item);
      }

      emit(
        state.copyWith(
          status: SyncStatus.failed,
          pendingCount: pendingItems.length,
          message: 'Sync failed',
        ),
      );
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 2));

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}

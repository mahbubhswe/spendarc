import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_snackbar.dart';
import '../../../core/injection.dart';
import '../../../core/undo_snackbar.dart';
import '../data/transaction_model.dart';
import 'sync_cubit.dart';
import 'transaction_cubit.dart';
import 'transaction_state.dart';
import 'widgets/add_transaction_sheet.dart';
import 'widgets/dashboard_section.dart';
import 'widgets/transaction_list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openAddTransactionSheet(BuildContext context) {
    final cubit = context.read<TransactionCubit>();
    cubit.clearErrorMessage();

    AddTransactionSheet.show(
      context,
      validationMessageBuilder: () =>
          context.read<TransactionCubit>().state.errorMessage,
      onSubmit: (title, amount, isExpense) {
        final added = cubit.addTransaction(title, amount, isExpense);

        if (!added) {
          return false;
        }

        context.read<SyncCubit>().syncPendingTransactions();

        AppSnackBar.show(
          context: context,
          message: 'This transaction has been added',
        );

        return true;
      },
    );
  }

  void _deleteWithUndo(BuildContext context, TransactionModel transaction) {
    final cubit = context.read<TransactionCubit>();

    cubit.deleteTransaction(transaction.id);

    UndoSnackBar.showTransactionDeleted(
      context: context,
      onUndo: () {
        cubit.restoreTransaction(transaction);
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    AppSnackBar.show(context: context, message: 'Coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TransactionCubit>()..loadTransactions()),
        BlocProvider(
          create: (_) => sl<SyncCubit>()
            ..startAutoSyncLoop()
            ..syncPendingTransactions(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('SpendArc')),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _openAddTransactionSheet(context),
              child: const Icon(Icons.add),
            ),
            body: MultiBlocListener(
              listeners: [
                BlocListener<SyncCubit, SyncState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == SyncStatus.synced,
                  listener: (context, _) {
                    context.read<TransactionCubit>().loadTransactions();
                  },
                ),
              ],
              child: BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  final cubit = context.read<TransactionCubit>();
                  final syncState = context.select(
                    (SyncCubit syncCubit) => syncCubit.state,
                  );

                  return Column(
                    children: [
                      DashboardSection(
                        balance: cubit.totalBalance,
                        income: cubit.totalIncome,
                        expense: cubit.totalExpense,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
                        child: _TransactionHeader(
                          onSeeAllTap: () => _showComingSoon(context),
                          syncState: syncState,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                        child: _TransactionFilterChips(
                          selectedFilter: state.filter,
                          onChanged: (filter) {
                            context.read<TransactionCubit>().setFilter(filter);
                          },
                        ),
                      ),
                      Expanded(
                        child: TransactionListSection(
                          transactions: state.filteredTransactions,
                          onDismissTransaction: (transaction) {
                            _deleteWithUndo(context, transaction);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransactionHeader extends StatelessWidget {
  final VoidCallback onSeeAllTap;
  final SyncState syncState;

  const _TransactionHeader({
    required this.onSeeAllTap,
    required this.syncState,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Your Transactions',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _SyncStatusBadge(syncState: syncState),
        TextButton(
          onPressed: onSeeAllTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('See All'),
        ),
      ],
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final SyncState syncState;

  const _SyncStatusBadge({required this.syncState});

  @override
  Widget build(BuildContext context) {
    if (!syncState.hasMessage) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    final isSyncing = syncState.status == SyncStatus.syncing;
    final isOffline = syncState.status == SyncStatus.offline;
    final isSynced = syncState.status == SyncStatus.synced;

    final color = isOffline
        ? Colors.red
        : isSynced
        ? Colors.green
        : Colors.blueGrey;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSyncing)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              isOffline ? Icons.cloud_off : Icons.cloud_done,
              size: 14,
              color: color,
            ),
          const SizedBox(width: 6),
          Text(
            syncState.message!,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionFilterChips extends StatelessWidget {
  final TransactionFilter selectedFilter;
  final ValueChanged<TransactionFilter> onChanged;

  const _TransactionFilterChips({
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _FilterChipItem(
            label: 'All',
            isSelected: selectedFilter == TransactionFilter.all,
            onTap: () => onChanged(TransactionFilter.all),
          ),
          _FilterChipItem(
            label: 'Income',
            isSelected: selectedFilter == TransactionFilter.income,
            onTap: () => onChanged(TransactionFilter.income),
          ),
          _FilterChipItem(
            label: 'Expense',
            isSelected: selectedFilter == TransactionFilter.expense,
            onTap: () => onChanged(TransactionFilter.expense),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

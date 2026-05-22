import 'package:flutter/material.dart';

import '../../data/transaction_model.dart';
import 'transaction_tile.dart';

class TransactionListSection extends StatelessWidget {
  final List<TransactionModel> transactions;
  final void Function(TransactionModel transaction)
      onDismissTransaction;

  const TransactionListSection({
    super.key,
    required this.transactions,
    required this.onDismissTransaction,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions yet'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(
        height: 6,
        thickness: 0.6,
      ),
      itemBuilder: (context, index) {
        final item = transactions[index];
        final delayMs = (index * 40).clamp(0, 240);

        return TweenAnimationBuilder<double>(
          key: ValueKey('anim_${item.id}'),
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 260 + delayMs),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 16),
                child: child,
              ),
            );
          },
          child: Dismissible(
            key: ValueKey('dismiss_${item.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
            onDismissed: (_) {
              onDismissTransaction(item);
            },
            child: TransactionTile(
              transaction: item,
            ),
          ),
        );
      },
    );
  }
}

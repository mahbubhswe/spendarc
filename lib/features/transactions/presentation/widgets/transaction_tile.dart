import 'package:flutter/material.dart';

import '../../data/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isSpend = transaction.isExpense;
    final statusLabel = isSpend ? 'Expense' : 'Income';
    final statusColor = isSpend ? Colors.red : Colors.green;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -2,
        vertical: -2,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 10,
      leading: CircleAvatar(
        radius: 16,
        child: Icon(
          isSpend ? Icons.arrow_upward : Icons.arrow_downward,
          size: 16,
        ),
      ),
      title: Text(
        transaction.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ),
      ),
      trailing: Text(
        'BDT ${transaction.amount.toStringAsFixed(0)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    );
  }
}

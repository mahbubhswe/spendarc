import 'package:flutter/material.dart';

import 'balance_card.dart';

class DashboardSection extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const DashboardSection({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
      child: BalanceCard(balance: balance, income: income, expense: expense),
    );
  }
}
